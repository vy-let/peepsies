//
//  PPIdentityMessage.m
//  Peepsies
//
//  Created by Tanner Paige Floisand on 5/22/14.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import "PPIdentityMessage.h"

@implementation PPIdentityMessage

-(id)initWithSender:(NSUUID *)sender senderName:(NSString *)name
{
    self = [super initWithType:@"identity" timestamp:[NSDate date]];
    
    if(!self)
    {
        return nil;
    }
    
    _sender = sender;
    _senderName = name;
    
    return self;
}

@end
