//
//  PPRequestMessage.h
//  Peepsies
//
//  Created by Tanner Paige Floisand on 5/22/14.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import "PPMessage.h"

@interface PPRequestMessage : PPMessage

- (id)initWithRequestedPostID:(NSUUID *)postID;
@property (nonatomic, readonly) NSUUID *requestedPostID;

@end
