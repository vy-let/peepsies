//
//  PPMentionMessage.m
//  Peepsies
//
//  Created by Tanner Paige Floisand on 5/22/14.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import "PPMentionMessage.h"
#import "NSArray+Iterable.h"

@implementation PPMentionMessage

-(id)initWithPostIDs:(NSArray *)postuuids timestamp:(NSDate *)messageTimestamp uuid:(NSUUID *)uuid
{
    self = [super initWithType:@"mention" timestamp:messageTimestamp uuid:uuid];
    
    if(!self)
    {
        return nil;
    }
    
    _postIDs = postuuids;
    
    return self;
}

-(NSMutableDictionary *)dictionaryDataRepresentation
{
    NSMutableDictionary *dict = [super dictionaryDataRepresentation];
    [dict setObject:[self.postIDs map:^(NSUUID *postID) {
        return [postID UUIDString];
    }] forKey:@"posts"];
    
    return dict;
}

@end
