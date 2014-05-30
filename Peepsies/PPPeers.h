//
//  PPPeers.h
//  Peepsies
//
//  Created by Taldar Baddley on 2014-5-23.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@class PPMessage;


@interface PPPeers : NSObject <MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate, MCSessionDelegate>

+ (void)initSingleton;
+ (PPPeers *)peers;
- (void)broadcastMessage:(PPMessage *)message;

- (NSDictionary *)knownPosts;

@end
