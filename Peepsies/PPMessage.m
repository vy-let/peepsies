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
#import "PPCensusMessage.h"
#import "PPIdentityMessage.h"
#import "PPRequestMessage.h"
#import "NSArray+Iterable.h"

@interface PPMessage ()

@end

@implementation PPMessage

-(id)initWithType:(NSString *)messageType timestamp:(NSDate *)messageTimestamp uuid:(NSUUID *)uuid
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    _type = [messageType copy];
    _timestamp = messageTimestamp ? messageTimestamp : [NSDate date];
    _uuid = uuid ? uuid : [NSUUID UUID];
    
    return self;
}

-(NSMutableDictionary *)dictionaryDataRepresentation
{
    return [@{
              @"type": self.type,
              @"timestamp": self.timestamp,
              @"uuid": [self.uuid UUIDString]
              
              } mutableCopy];
}

-(NSData *)dataRepresentation
{
    return [NSPropertyListSerialization dataWithPropertyList:[self dictionaryDataRepresentation] format:NSPropertyListBinaryFormat_v1_0 options:0 error:nil];

}

+(PPMessage *)messageWithData:(NSData *)data
{
    NSDictionary *dict = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:NULL error:nil];
    
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
            mesg = [[PPPicturePostMessage alloc] initWithJPEGData:messageData
                                                           sender:senderuuid
                                                       senderName:senderName
                                                        timestamp:date
                                                             uuid:uuid];
        }
    }
    else if ([type isEqualToString:@"mention"])
    {
        NSArray *uuids = [dict objectForKey:@"posts"];
        NSArray *mmuuids = [uuids map:^(NSString *suuid) {
            return [[NSUUID alloc] initWithUUIDString:suuid];
        }];
        
        mesg = [[PPMentionMessage alloc] initWithPostIDs:mmuuids timestamp:date uuid:uuid];
    }
    else if ([type isEqualToString:@"census"])
    {
        mesg = [[PPCensusMessage alloc] init];
    }
    else if([type isEqualToString:@"identity"])
    {
        NSString *senderName = [dict objectForKey:@"sender-name"];
        NSUUID *senderuuid = [[NSUUID alloc] initWithUUIDString:[dict objectForKey:@"sender"]];
        
        mesg = [[PPIdentityMessage alloc] initWithSender:senderuuid senderName:senderName timestamp:date uuid:uuid];
    }
    else if([type isEqualToString:@"request"])
    {
        NSUUID *requesteduuid = [[NSUUID alloc] initWithUUIDString:[dict objectForKey:@"requestedPostID"]];

        mesg = [[PPRequestMessage alloc] initWithRequestedPostID:requesteduuid timestamp:date uuid:uuid];
    }
    
    return mesg;
}

@end
