//
//  PPPostMessage.m
//  Peepsies
//
//  Created by Tanner Paige Floisand on 5/21/14.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import "PPPostMessage.h"

@implementation PPPostMessage

-(id)initWithSender:(NSUUID *)sender senderName:(NSString *)name
{
    self = [super initWithType:@"post" timestamp:[NSDate date]]; 
    
    if(!self)
    {
        return nil;
    }
    
    _sender = sender;
    _senderName = name;
    
    return self;
}

@dynamic bodytype;

@end
