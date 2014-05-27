//
//  PPDrawView.h
//  Peepsies
//
//  Created by Taldar Baddley on 2014-5-26.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import "DrawView.h"

@interface PPDrawView : DrawView

- (void)setTouchEndedTarget:(id)target action:(SEL)action;

@end
