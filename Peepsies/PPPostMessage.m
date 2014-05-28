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

-(NSMutableDictionary *)dictionaryDataRepresentation
{
    NSMutableDictionary *dict = [super dictionaryDataRepresentation];
    [dict setObject:self.sender forKey:@"sender"];
    [dict setObject:self.senderName forKey:@"sender-name"];
    return dict;
}

@dynamic bodytype;

@end
