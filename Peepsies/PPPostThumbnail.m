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
        
        UIImageView *pictureHolder = [[UIImageView alloc] initWithFrame:self.bounds];
        pictureHolder.contentMode  = UIViewContentModeScaleAspectFill;
        pictureHolder.clipsToBounds = YES; 
        [self.contentView addSubview:pictureHolder];
        self.imageView = pictureHolder;
        
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
