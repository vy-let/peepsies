//
//  PPRequestMessage.m
//  Peepsies
//
//  Created by Tanner Paige Floisand on 5/22/14.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import "PPRequestMessage.h"

@implementation PPRequestMessage

-(id)initWithRequestedPostID:(NSUUID *)postID
{
    self = [super initWithType:@"request" timestamp:[NSDate date]];
    
    if(!self)
    {
        return nil;
    }
    
    _requestedPostID = postID;
    
    return self;
}

@end
