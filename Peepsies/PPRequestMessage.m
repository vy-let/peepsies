//
//  PPRequestMessage.m
//  Peepsies
//
//  Created by Tanner Paige Floisand on 5/22/14.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import "PPRequestMessage.h"

@implementation PPRequestMessage

-(id)initWithRequestedPostID:(NSUUID *)postID timestamp:(NSDate *)messageTimestamp uuid:(NSUUID *)uuid
{
    self = [super initWithType:@"request" timestamp:messageTimestamp uuid:uuid];
    
    if(!self)
    {
        return nil;
    }
    
    _requestedPostID = postID;
    
    return self;
}

-(NSMutableDictionary *)dictionaryDataRepresentation
{
    NSMutableDictionary *dict = [super dictionaryDataRepresentation];
    [dict setObject:[self.requestedPostID UUIDString] forKey:@"requestedPostID"];
    return dict;
}

@end
