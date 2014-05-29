//
//  PPCensusMessage.m
//  Peepsies
//
//  Created by Tanner Paige Floisand on 5/22/14.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import "PPCensusMessage.h"

@implementation PPCensusMessage

-(id)initWithTimestamp:(NSDate *)messageTimestamp uuid:(NSUUID *)uuid
{
    return [super initWithType:@"census" timestamp:messageTimestamp uuid:uuid];
    
}

/*
 
 Doesn't have anything to override...
 
-(NSMutableDictionary *)dictionaryDataRepresentation
{
    NSMutableDictionary *dict = [super dictionaryDataRepresentation];

    return dict;
}
*/
 
@end
