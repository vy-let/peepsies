//
//  PPDrawView.m
//  Peepsies
//
//  Created by Taldar Baddley on 2014-5-26.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import <objc/message.h>
#import "PPDrawView.h"

@interface PPDrawView ()
@property (nonatomic, weak) id touchEndedTarget;
@property (nonatomic)      SEL touchEndedAction;
@end



@implementation PPDrawView

- (void)setTouchEndedTarget:(id)target action:(SEL)action {
    [self setTouchEndedTarget:target];
    [self setTouchEndedAction:action];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (_touchEndedAction)
        objc_msgSend(_touchEndedTarget, _touchEndedAction, self);
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    if (_touchEndedAction)
        objc_msgSend(_touchEndedTarget, _touchEndedAction, self);
}

@end
