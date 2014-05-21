//
//  PPMessage.h
//  Peepsies
//
//  Created by Tanner Paige Floisand on 5/21/14.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPMessage : NSObject

-(id)initWithType:(NSString *)messageType timestamp :(NSDate *)messageTimestamp;
@property (nonatomic, readonly) NSString *type;
@property (nonatomic, readonly) NSDate *timestamp;
@property (nonatomic, readonly) NSUUID *uuid; 

@end
