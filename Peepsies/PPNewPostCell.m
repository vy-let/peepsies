//
//  PPNewPostCell.m
//  Peepsies
//
//  Created by Taldar Baddley on 2014-5-21.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import "PPNewPostCell.h"

@implementation PPNewPostCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        UIButton *scribblyButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [scribblyButton setFrame:[self bounds]];
        [scribblyButton setImage:[UIImage imageNamed:@"PencildrawTemplate"] forState:UIControlStateNormal];
        [scribblyButton setContentMode:UIViewContentModeCenter];
        
        [[self contentView] addSubview:scribblyButton];
        
        [scribblyButton addTarget:self action:@selector(startNewPost) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}



- (void)startNewPost {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PPNewPostNote" object:self];
}


@end
