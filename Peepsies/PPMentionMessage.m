//
//  PPMentionMessage.m
//  Peepsies
//
//  Created by Tanner Paige Floisand on 5/22/14.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import "PPMentionMessage.h"

@implementation PPMentionMessage

-(id)initWithPostIDs:(NSArray *)postuuids
{
    self = [super initWithType:@"mention" timestamp:[NSDate date]];
    
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
    [dict setObject:self.postIDs forKey:@"posts"];  
    return dict;
}

@end
