//
//  PPPostMessage.h
//  Peepsies
//
//  Created by Tanner Paige Floisand on 5/21/14.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import "PPMessage.h"

@interface PPPostMessage : PPMessage

-(id)initWithSender:(NSUUID *)sender senderName:(NSString *)name;
@property (nonatomic, readonly) NSString *bodytype;
@property (nonatomic, readonly) NSUUID *sender;
@property (nonatomic, readonly) NSString *senderName;

@end
