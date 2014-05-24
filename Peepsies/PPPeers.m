//
//  PPPeers.m
//  Peepsies
//
//  Created by Taldar Baddley on 2014-5-23.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import "PPPeers.h"


@interface PPPeers ()

@property (nonatomic) MCPeerID *ourID;
@property (nonatomic) MCSession *ourPublishedSession;
@property (nonatomic) NSMutableSet *sessionsWeBelongTo;
@property (nonatomic) dispatch_queue_t eventQueue;
@property (nonatomic) NSDictionary *posts;
@property (nonatomic) MCNearbyServiceAdvertiser *serviceAdvertiser;
@property (nonatomic) MCNearbyServiceBrowser *serviceBrowser;

@end


@implementation PPPeers

static PPPeers *_sharedSingleton = nil;
+ (void)initialize {
    //_sharedSingleton = [[PPPeers alloc] init];
}

- (PPPeers *)peers {
    // TODO neither create the singleton nor return it until the username has been established.
    return _sharedSingleton;
}


- (id)init {
    if (!(self = [super init]))
        return nil;
    
    NSString *displayName = [[NSUserDefaults standardUserDefaults] objectForKey:@"PPUserDisplayName"];
    
    _ourID = [[MCPeerID alloc] initWithDisplayName:displayName];
    _ourPublishedSession = [[MCSession alloc] initWithPeer:_ourID];
    _sessionsWeBelongTo = [NSMutableSet setWithCapacity:8];
    _eventQueue = dispatch_queue_create("PPPeersEventQueue", DISPATCH_QUEUE_SERIAL);
    
    _posts = [NSMutableDictionary dictionaryWithCapacity:30];
    
    _serviceAdvertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:_ourID discoveryInfo:@{} serviceType:@"pp-peepsies"];
    _serviceBrowser = [[MCNearbyServiceBrowser alloc] initWithPeer:_ourID serviceType:@"pp-peepsies"];
    
    [_serviceAdvertiser startAdvertisingPeer];
    
    dispatch_async(_eventQueue, ^{
        [self fillOurSession];
    });
    
    return self;
}

-(void)fillOurSession
{
    
}

#pragma mark - advertiser delegate protocol

-(void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession *))invitationHandler
{
    
}

-(void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error
{
    
}

#pragma mark - browser delegate protocol

-(void)browser:(MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error
{
    
}

-(void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    
}

-(void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    dispatch_async(_eventQueue, ^{
        [self fillOurSession];
    });
}

@end
