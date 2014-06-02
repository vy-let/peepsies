//
//  PPPeers.m
//  Peepsies
//
//  Created by Taldar Baddley on 2014-5-23.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import "PPPeers.h"
#import "NSArray+Iterable.h"
#import "NSSet+Iterable.h"

#import "PPMessage.h"
#import "PPPostMessage.h"
#import "PPCensusMessage.h"
#import "PPIdentityMessage.h"
#import "PPMentionMessage.h"
#import "PPRequestMessage.h"


@interface PPPeers ()

// All nonatomic, because the only ones we change, we do on the event queue.

@property (nonatomic) MCPeerID *ourID;
@property (nonatomic) MCSession *ourPublishedSession;
@property (nonatomic) NSMutableSet *sessionsWeBelongTo;
@property (nonatomic) NSMutableDictionary *posts;
@property (nonatomic) dispatch_queue_t eventQueue;
@property (nonatomic) MCNearbyServiceAdvertiser *serviceAdvertiser;
@property (nonatomic) MCNearbyServiceBrowser *serviceBrowser;

@property (nonatomic) NSMutableDictionary *postIDsSeenBySessions;
@property (nonatomic) NSMutableDictionary *lastCensus;

@property (nonatomic) BOOL isFillingOurSession;
@property (nonatomic) NSMutableSet *possiblePeersToInvite;

@end






@implementation PPPeers

static PPPeers *_sharedSingleton = nil;

+ (void)initSingleton {
    _sharedSingleton = [[PPPeers alloc] init];
}



+ (PPPeers *)peers {
    return _sharedSingleton;
}



- (id)init {
    if (!(self = [super init]))
        return nil;
    
    NSString *displayName = [[NSUserDefaults standardUserDefaults] objectForKey:@"PPUsername"];
    
    _ourID = [[MCPeerID alloc] initWithDisplayName:displayName];
    _ourPublishedSession = [[MCSession alloc] initWithPeer:_ourID];
    _sessionsWeBelongTo = [NSMutableSet setWithCapacity:8];
    _eventQueue = dispatch_queue_create("PPPeersEventQueue", DISPATCH_QUEUE_SERIAL);
    
    _posts = [NSMutableDictionary dictionaryWithCapacity:30];
    _postIDsSeenBySessions = [NSMutableDictionary dictionaryWithCapacity:8];
    _lastCensus = [NSMutableDictionary dictionaryWithCapacity:30];
    
    _serviceAdvertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:_ourID discoveryInfo:@{} serviceType:@"pp-peepsies"];
    _serviceBrowser = [[MCNearbyServiceBrowser alloc] initWithPeer:_ourID serviceType:@"pp-peepsies"];
    [_serviceAdvertiser setDelegate:self];
    [_serviceBrowser setDelegate:self];
    [_ourPublishedSession setDelegate:self];
    
    [_serviceAdvertiser startAdvertisingPeer];
    
    dispatch_async(_eventQueue, ^{
        [self fillOurSession];
    });
    
    return self;
}

- (void)peep {
    dispatch_async(_eventQueue, ^{
        NSLog(@"Peep!");
    });
}



#pragma mark - things we can do for other peeps.



// Note that this blocks for the event queue,
// so cannot be called *from* the event queue.
// It is designed solely for outsiders.
- (NSDictionary *)knownPosts {
    __block NSDictionary *knowns;
    dispatch_sync(_eventQueue, ^{
        knowns = [_posts copy];
    });
    
    return knowns;
}



- (void)broadcastMessage:(PPMessage *)message {
    dispatch_async(_eventQueue, ^{
        [self propagatePost:message asSeenOn:nil];
    });
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PPReceivedNewPost" object:self userInfo:@{@"PPPost": message}];
}



#pragma mark - advertiser delegate protocol



-(void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession *))invitationHandler
{
    NSLog(@"Received Invitation");
    MCSession *sessionWithPeer = [[MCSession alloc] initWithPeer:_ourID];
    [sessionWithPeer setDelegate:self];
    dispatch_async(_eventQueue, ^{
        [_sessionsWeBelongTo addObject:sessionWithPeer];
    });
    invitationHandler(YES, sessionWithPeer);
}



-(void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error
{
    NSLog(@"Network down? %@", error);
}



#pragma mark - browser delegate protocol



-(void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error
{
    NSLog(@"Network down? %@", error);
}



-(void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    NSLog(@"Found peer %@", peerID);
    dispatch_async(_eventQueue, ^{
        [_possiblePeersToInvite addObject:peerID];
    });
}



-(void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    NSLog(@"Lost peer %@", peerID);
    dispatch_async(_eventQueue, ^{
        [self fillOurSession];
    });
}



#pragma mark - session delegate protocol



- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    NSLog(@"Received message from peer %@", peerID);
    PPMessage *receivedMessage = [PPMessage messageWithData:data];
    
    dispatch_async(_eventQueue, ^{
        
        if ([receivedMessage isKindOfClass:[PPIdentityMessage class]]) {
            // Store user id & name for later.
            PPIdentityMessage *ident = (PPIdentityMessage *)receivedMessage;
            [_lastCensus setObject:[ident senderName] forKey:[ident sender]];
            
            // Pass along the message!
            [self propagatePost:ident asSeenOn:session];
            
        } else if ([receivedMessage isKindOfClass:[PPCensusMessage class]]) {
            [self handleCensus:receivedMessage fromSession:session];
        
        } else if ([receivedMessage isKindOfClass:[PPMentionMessage class]]) {
            [self handleMentions:receivedMessage fromPeer:peerID onSession:session];
            
        } else if ([receivedMessage isKindOfClass:[PPRequestMessage class]]) {
            [self handleRequest:receivedMessage fromPeer:peerID onSession:session];
            
        } else if ([receivedMessage isKindOfClass:[PPPostMessage class]]) {
            [self handleIncomingPost:receivedMessage fromSession:session];
            
        }
        
    });
}



- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    dispatch_async(_eventQueue, ^{
        if (state == MCSessionStateNotConnected) {
            NSLog(@"Peer %@ did not connect.", peerID);
            [self fillOurSession];
            
        } else if (state == MCSessionStateConnected) {
            // Unconditionally mention all our posts
            NSLog(@"Peer %@ connected.", peerID);
            NSMutableArray *allPostIDs = [NSMutableArray arrayWithCapacity:[_posts count]];
            [_posts enumerateKeysAndObjectsUsingBlock:^(NSUUID *postID, PPMessage *postItself, BOOL *stop) {
                [allPostIDs addObject:postID];
            }];
            [self postMessage:[[PPMentionMessage alloc] initWithPostIDs:allPostIDs timestamp:nil uuid:nil]
                       toPeer:peerID
                    onSession:session];
            
        } // else? meh.
        
    });
}



#pragma mark session delegate things we don't do
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress { }
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error { }
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID { }
- (void)session:(MCSession *)session didReceiveCertificate:(NSArray *)certificate fromPeer:(MCPeerID *)peerID certificateHandler:(void (^)(BOOL))certificateHandler {
    certificateHandler(YES);
}



#pragma mark - private tasks



- (void)handleIncomingPost:(PPPostMessage *)post fromSession:(MCSession *)session {
    // Post it to the interface!
    NSLog(@"Receive Post");
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PPReceivedNewPost"
                                                            object:self
                                                          userInfo:@{@"PPPost": post}];
    });
    
    [self propagatePost:post asSeenOn:session];
    
}



- (void)propagatePost:(PPMessage *)message asSeenOn:(MCSession *)session {
    NSUUID *messageID = [message uuid];
    NSLog(@"Propagate post id %@", messageID);
    
    [_posts setObject:message forKey:messageID];
    [self mentionPosts:@[messageID]];
    [self postID:messageID wasSeenBySession:session];
}



- (void)handleMentions:(PPMentionMessage *)mesg fromPeer:(MCPeerID *)peerID onSession:(MCSession *)session {
    NSLog(@"Posts %@ were mentioned.", [mesg postIDs]);
    
    NSArray *unknownMessageIDs = [[mesg postIDs] select:^BOOL(NSUUID *mesgID) {
        return [_posts objectForKey:mesgID] ? NO : YES;
    }];
    
    for (NSUUID *mesgID in unknownMessageIDs) {
        [self postRequestForMessage:mesgID toPeer:peerID onSession:session];
        
        // If, after 10 seconds, we still haven't seen that promised message,
        // broadcast a request for it:
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), _eventQueue, ^{
            if (![_posts objectForKey:mesgID])
                [self postRequestForMessage:mesgID toPeer:nil onSession:nil];
        });
    }
    
    
}



- (void)handleRequest:(PPRequestMessage *)mesg fromPeer:(MCPeerID *)peerID onSession:(MCSession *)session {
    NSLog(@"Post %@ was requested.", [mesg requestedPostID]);
    
    PPPostMessage *requestedPost = [_posts objectForKey:[mesg requestedPostID]];
    if (!requestedPost) return;  // It's OK to not file a response.
    
    [self postMessage:requestedPost toPeer:peerID onSession:session];
    
}



- (void)handleCensus:(PPCensusMessage *)mesg fromSession:(MCSession *)session {
    NSLog(@"Ignoring census.");
    
}



// THIS METHOD MAY ONLY BE CALLED FROM THE EVENT QUEUE!!!
-(void)fillOurSession
{
    if (_isFillingOurSession) return;
    _isFillingOurSession = YES;
    
    _possiblePeersToInvite = [NSMutableSet setWithCapacity:8];
    [_serviceBrowser startBrowsingForPeers];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)( 3 * NSEC_PER_SEC )), _eventQueue, ^{
        [_serviceBrowser stopBrowsingForPeers];  // 3 seconds. Done browsing.
        
        NSSet *localPeers = [NSSet setWithArray:[_ourPublishedSession connectedPeers]];
        NSSet *peersWeAlreadyKnow = localPeers;
//        NSSet *peersWeAlreadyKnow = [_sessionsWeBelongTo fromSeed:localPeers reduce:^(NSSet *memo, MCSession *externalSession) {
//            return [memo setByAddingObjectsFromArray:[externalSession connectedPeers]];
//        }];
        
        NSArray *peersWeDontKnow = [[_possiblePeersToInvite select:^BOOL(MCPeerID *possiblePeer) {
            return ![peersWeAlreadyKnow containsObject:possiblePeer];
        }] shuffled];
        
        if ( [peersWeDontKnow count] > (7 - [peersWeAlreadyKnow count]) ) {
            peersWeDontKnow = [peersWeDontKnow objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 7 - [peersWeAlreadyKnow count])]];
        }
        
        
        for (MCPeerID *peer in peersWeDontKnow) {
            
            [_serviceBrowser invitePeer:peer toSession:_ourPublishedSession withContext:nil timeout:30];
        }
        
        
        if ([peersWeDontKnow count] + [peersWeAlreadyKnow count] < 7)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), _eventQueue, ^{
                [self fillOurSession];
            });
        
        _isFillingOurSession = NO;
        [_serviceBrowser stopBrowsingForPeers];
        _possiblePeersToInvite = nil;
        
    });
    
}



- (void)postID:(NSUUID *)poid wasSeenBySession:(MCSession *)sesh {
    if (!sesh) return;
    NSValue *seshValue = [NSValue valueWithNonretainedObject:sesh];
    
    NSMutableSet *idsForSesh = [_postIDsSeenBySessions objectForKey:seshValue];
    if (!idsForSesh) {
        idsForSesh = [NSMutableSet setWithCapacity:10];
        [_postIDsSeenBySessions setObject:idsForSesh forKey:seshValue];
    }
    
    [idsForSesh addObject:poid];
}



- (BOOL)wasPostID:(NSUUID *)poid seenBySession:(MCSession *)sesh {
    NSValue *seshValue = [NSValue valueWithNonretainedObject:sesh];
    
    NSSet *idsForSesh = [_postIDsSeenBySessions objectForKey:seshValue];
    if (!idsForSesh)
        idsForSesh = [NSSet set];
    
    return [idsForSesh containsObject:poid];
}



- (void)mentionPosts:(NSArray *)postIDs {
    for (MCSession *session in [self ALL_THE_SESSIONS]) {
        
        NSArray *unMentionedPosts = [postIDs select:^BOOL(NSUUID *postID) {
            return ![self wasPostID:postID seenBySession:session];
        }];
        
        if ([unMentionedPosts count] > 0)
            [self postMessage:[[PPMentionMessage alloc] initWithPostIDs:unMentionedPosts timestamp:nil uuid:nil]
                       toPeer:nil
                    onSession:session];
    }
}



- (void)postRequestForMessage:(NSUUID *)messageID toPeer:(MCPeerID *)peer onSession:(MCSession *)sesh {
    [self postMessage:[[PPRequestMessage alloc] initWithRequestedPostID:messageID timestamp:nil uuid:nil]
               toPeer:peer
            onSession:sesh];
    
}



// If session is nil, all sessions are selected, and peer is ignored.
// If peer is nil, all peers within the specified session are messaged.
- (void)postMessage:(PPMessage *)message toPeer:(MCPeerID *)peer onSession:(MCSession *)session {
    if (session) {
        NSArray *peers = peer ? @[peer] : [session connectedPeers];
        [session sendData:[message dataRepresentation]
                  toPeers:peers
                 withMode:MCSessionSendDataReliable
                    error:NULL];
        
    } else {
        for (MCSession *singleSession in [self ALL_THE_SESSIONS])
            [self postMessage:message toPeer:nil onSession:singleSession];
        
    }
    
}



- (NSSet *)ALL_THE_SESSIONS {
    // Talk to ALL THE THINGS!!!
    return [_sessionsWeBelongTo setByAddingObject:_ourPublishedSession];
}













@end
