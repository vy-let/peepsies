//
//  PPPostMessage.m
//  Peepsies
//
//  Created by Tanner Paige Floisand on 5/21/14.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import "PPPostMessage.h"

@implementation PPPostMessage

-(id)initWithSender:(NSUUID *)sender senderName:(NSString *)name timestamp:(NSDate *)messageTimestamp uuid:(NSUUID *)uuid
{
    self = [super initWithType:@"post" timestamp:messageTimestamp uuid:uuid];
    
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
