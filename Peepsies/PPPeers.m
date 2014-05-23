//
//  PPPeers.m
//  Peepsies
//
//  Created by Taldar Baddley on 2014-5-23.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import "PPPeers.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>


@interface PPPeers ()

@property (nonatomic) MCPeerID *ourID;
@property (nonatomic) MCSession *ourPublishedSession;
@property (nonatomic) NSMutableSet *sessionsWeBelongTo;
@property (nonatomic) dispatch_queue_t eventQueue;
@property (nonatomic) NSDictionary *posts;

@end


@implementation PPPeers

static PPPeers *_sharedSingleton = nil;
+ (void)initialize {
    _sharedSingleton = [[PPPeers alloc] init];
}

- (PPPeers *)peers {
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
    
    
    return self;
}




@end
