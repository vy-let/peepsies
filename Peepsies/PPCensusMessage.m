//
//  PPCensusMessage.m
//  Peepsies
//
//  Created by Tanner Paige Floisand on 5/22/14.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import "PPCensusMessage.h"

@implementation PPCensusMessage

-(id)init
{
    return [super initWithType:@"census" timestamp:[NSDate date]];
    
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
