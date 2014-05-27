//
//  PPDrawingRecordView.h
//  Peepsies
//
//  Created by Taldar Baddley on 2014-5-26.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PPDrawingStroke;

@interface PPDrawingRecordView : UIView

- (void)pushStroke:(PPDrawingStroke *)stroke;
- (void)pushStroke:(UIBezierPath *)stroke weight:(CGFloat)weight color:(UIColor *)color;
//- (void)pushStroke:(UIBezierPath *)stroke color:(UIColor *)color;

- (PPDrawingStroke *)peekStroke;
- (PPDrawingStroke *)popStroke;

- (UIImage *)imageWithBackgroundColor:(UIColor *)bgColor;


@end
