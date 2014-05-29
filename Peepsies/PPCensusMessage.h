//
//  PPCensusMessage.h
//  Peepsies
//
//  Created by Tanner Paige Floisand on 5/22/14.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import "PPMessage.h"

@interface PPCensusMessage : PPMessage

-(id)initWithTimestamp:(NSDate *)messageTimestamp uuid:(NSUUID *)uuid;

@end
