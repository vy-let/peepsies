//
//  PPMessage.m
//  Peepsies
//
//  Created by Tanner Paige Floisand on 5/21/14.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import "PPMessage.h"

@implementation PPMessage

-(id)initWithType:(NSString *)messageType timestamp:(NSDate *)messageTimestamp
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    _type = [messageType copy];
    _timestamp = messageTimestamp;
    _uuid = [NSUUID UUID]; 
    
    return self;
}

@end
