//
//  PPDrawingStroke.h
//  Peepsies
//
//  Created by Taldar Baddley on 2014-5-26.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PPDrawingStroke : NSObject

@property (nonatomic, readonly) UIBezierPath *stroke;
@property (nonatomic, readonly) CGFloat weight;
@property (nonatomic, readonly) UIColor *color;

- (id)initWithStroke:(UIBezierPath *)stroke weight:(CGFloat)weight color:(UIColor *)color;
//- (id)initWithStroke:(UIBezierPath *)stroke color:(UIColor *)color;

@end
