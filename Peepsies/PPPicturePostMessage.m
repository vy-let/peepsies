//
//  PPPicturePostMessage.m
//  Peepsies
//
//  Created by Taldar Baddley on 2014-5-27.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import "PPPicturePostMessage.h"
#import <SDWebImage/SDImageCache.h>

@implementation PPPicturePostMessage

- (id)initWithImage:(UIImage *)image imageData:(NSData *)imageDataOrNil sender:(NSUUID *)sender senderName:(NSString *)name {
    if (!(self = [super initWithSender:sender senderName:name]))
        return nil;
    
    if (imageDataOrNil)
        [[SDImageCache sharedImageCache] storeImage:image recalculateFromImage:YES imageData:imageDataOrNil forKey:[[self uuid] UUIDString]  toDisk:YES];
    else
        [[SDImageCache sharedImageCache] storeImage:image forKey:[[self uuid] UUIDString] toDisk:YES];
    
    return self;
}

- (UIImage *)image {
    // Slow? Maybe. But not too slow, and pretty easy.
    return [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[[self uuid] UUIDString]];
}

- (NSString *)bodytype {
    return @"jpeg";
}

@end
