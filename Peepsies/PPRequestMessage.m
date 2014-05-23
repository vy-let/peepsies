//
//  PPRequestMessage.m
//  Peepsies
//
//  Created by Tanner Paige Floisand on 5/22/14.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import "PPRequestMessage.h"

@implementation PPRequestMessage

-(id)init
{
    self = [super initWithType:@"request" timestamp:[NSDate date]];
    
    if(!self)
    {
        return nil;
    }
    
    return self;
}

@end
