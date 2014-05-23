//
//  PPMentionMessage.m
//  Peepsies
//
//  Created by Tanner Paige Floisand on 5/22/14.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import "PPMentionMessage.h"

@implementation PPMentionMessage

-(id)initWithPosts:(NSArray *)postuuids
{
    self = [super initWithType:@"mention" timestamp:[NSDate date]];
    
    if(!self)
    {
        return nil;
    }
    
    _posts = postuuids;
    
    return self;
}

@end
