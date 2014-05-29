//
//  PPMentionMessage.h
//  Peepsies
//
//  Created by Tanner Paige Floisand on 5/22/14.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import "PPMessage.h"

@interface PPMentionMessage : PPMessage

-(id)initWithPostIDs:(NSArray *)postuuids timestamp:(NSDate *)messageTimestamp uuid:(NSUUID *)uuid;
@property NSArray *postIDs;

@end
