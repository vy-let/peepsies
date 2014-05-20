//
//  PPPostThumbnail.m
//  Peepsies
//
//  Created by Tanner Paige Floisand on 5/19/14.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import "PPPostThumbnail.h"

@implementation PPPostThumbnail

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:self.imageView]; 
    }
    return self;
}

- (void)setThumbnail:(UIImage *)thumbnail
{
    [self.imageView setImage:thumbnail];
}

- (UIImage *)thumbnail
{
    return [self.imageView image];
}

@end
