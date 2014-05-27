//
//  PPDrawingRecordView.m
//  Peepsies
//
//  Created by Taldar Baddley on 2014-5-26.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import "PPDrawingRecordView.h"
#import "PPDrawingStroke.h"

@interface PPDrawingRecordView ()

@property (nonatomic) NSMutableArray *strokeStack;

@end



@implementation PPDrawingRecordView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _strokeStack = [NSMutableArray arrayWithCapacity:50];
        [self setOpaque:NO];
        
    }
    return self;
}


- (void)pushStroke:(PPDrawingStroke *)stroke {
    [_strokeStack addObject:stroke];
    [self setNeedsDisplay];
}


- (void)pushStroke:(UIBezierPath *)stroke weight:(CGFloat)weight color:(UIColor *)color {
    [self pushStroke:[[PPDrawingStroke alloc] initWithStroke:stroke
                                                      weight:weight
                                                       color:color]];
}


- (PPDrawingStroke *)peekStroke {
    return [_strokeStack lastObject];
}

- (PPDrawingStroke *)popStroke {
    PPDrawingStroke *poppedStroke = [_strokeStack lastObject];
    if (poppedStroke) [_strokeStack removeLastObject];
    
    return poppedStroke;
}

//- (void)pushStroke:(UIBezierPath *)stroke color:(UIColor *)color {
//    [self pushStroke:[[PPDrawingStroke alloc] initWithStroke:stroke
//                                                       color:color]];
//}


- (void)drawRect:(CGRect)rect {
    
    for (PPDrawingStroke *drawingStroke in _strokeStack) {
        UIBezierPath *stroke = [drawingStroke stroke];
        
        [[drawingStroke color] setStroke];
        
        [stroke setLineWidth:[drawingStroke weight]];
        [stroke setLineCapStyle:kCGLineCapRound];
        [stroke setLineJoinStyle:kCGLineJoinRound];
        [stroke setMiterLimit:10];
        [stroke strokeWithBlendMode:kCGBlendModeNormal alpha:1];
    }
    
}



- (UIImage *)imageWithBackgroundColor:(UIColor *)bgColor {
    UIGraphicsBeginImageContext([self bounds].size);
    CGContextRef drawingContext = UIGraphicsGetCurrentContext();
    
    if (bgColor) {
        CGContextSetFillColorWithColor(drawingContext, [bgColor CGColor]);
        CGContextFillRect(drawingContext, [self bounds]);
    }
    
    [[self layer] renderInContext:drawingContext];
    UIImage *renderedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return renderedImage;
}



@end
