//
//  PPDrawingStroke.m
//  Peepsies
//
//  Created by Taldar Baddley on 2014-5-26.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import "PPDrawingStroke.h"

@implementation PPDrawingStroke

- (id)initWithStroke:(UIBezierPath *)stroke weight:(CGFloat)weight color:(UIColor *)color {
    if (!(self = [super init]))
        return nil;
    
    _stroke = [stroke copy];  // The only possibly-mutable member.
    _weight = weight;
    _color  = color;
    
    return self;
}

//- (id)initWithStroke:(UIBezierPath *)stroke color:(UIColor *)color {
//    if (!(self = [super init]))
//        return nil;
//    
//    _stroke = [stroke copy];  // The only possibly-mutable member.
//    _color  = color;
//    
//    return self;
//}

@end
