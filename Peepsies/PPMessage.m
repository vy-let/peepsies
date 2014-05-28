//
//  PPMessage.m
//  Peepsies
//
//  Created by Tanner Paige Floisand on 5/21/14.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import "PPMessage.h"
#import "PPPicturePostMessage.h"
#import "PPMentionMessage.h"


@interface PPMessage ()

@end


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

-(NSMutableDictionary *)dictionaryDataRepresentation
{
    return [@{
              @"type": self.type,
              @"timestamp": self.timestamp,
              @"uuid": self.uuid
              
              } mutableCopy];
}

-(NSData *)dataRepresentation
{
    return [NSPropertyListSerialization dataWithPropertyList:[self dictionaryDataRepresentation] format:NSPropertyListBinaryFormat_v1_0 options:0 error:nil];

}

+(PPMessage *)messageWithData:(NSData *)data
{
    NSDictionary *dict = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:NSPropertyListBinaryFormat_v1_0 error:nil];
    
    if (![dict respondsToSelector:@selector(objectForKey:)])
        return nil;
    
    NSString *type = [dict objectForKey:@"type"];
    NSDate *date = [dict objectForKey:@"timestamp"];
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:[dict objectForKey:@"uuid"]];
    
    PPMessage *mesg = nil;
    
    
    if([type isEqualToString:@"post"])
    {
        NSString *bodytype = [dict objectForKey:@"body-type"];
        NSString *senderName = [dict objectForKey:@"sender-name"];
        NSUUID *senderuuid = [[NSUUID alloc] initWithUUIDString:[dict objectForKey:@"sender"]];
        NSData *messageData = [dict objectForKey:@"body"];
        
        if([bodytype isEqualToString:@"jpeg"])
        {
            mesg = [[PPPicturePostMessage alloc] initWithImage:[UIImage imageWithData:messageData]
                                                                           imageData:messageData
                                                                              sender:senderuuid
                                                                          senderName:senderName];
        }
    }
    else if ([type isEqualToString:@"mention"])
    {
        NSArray *uuids = [dict objectForKey:@"posts"];
        NSMutableArray *muuids = [NSMutableArray arrayWithCapacity:[uuids count]];
        
        for(NSString *suuid in uuids)
        {
            [muuids addObject:[[NSUUID alloc] initWithUUIDString:suuid]];
        }
        
        mesg = [[PPMentionMessage alloc] initWithPostIDs:muuids];
    }
    else if ([type isEqualToString:@"census"])
    {
        
    }
    else if([type isEqualToString:@"identity"])
    {
        
    }
    else if([type isEqualToString:@"request"])
    {
        
    }
    
    mesg.uuid = uuid;
    mesg.timestamp = date;
    return mesg;
}

@end
