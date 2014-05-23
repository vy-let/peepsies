//
//  PPMentionMessage.h
//  Peepsies
//
//  Created by Tanner Paige Floisand on 5/22/14.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import "PPMessage.h"

@interface PPMentionMessage : PPMessage

-(id)initWithPosts:(NSArray *)postuuids;
@property NSArray *posts;

@end
