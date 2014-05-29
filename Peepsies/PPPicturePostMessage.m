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

- (id)initWithJPEGData:(NSData *)imageData sender:(NSUUID *)sender senderName:(NSString *)name timestamp:(NSDate *)messageTimestamp uuid:(NSUUID *)uuid {
    if (!(self = [super initWithSender:sender senderName:name timestamp:messageTimestamp uuid:uuid]))
        return nil;
    
    UIImage *loaderatedImage = [UIImage imageWithData:imageData];
    [[SDImageCache sharedImageCache] storeImage:loaderatedImage recalculateFromImage:YES imageData:imageData forKey:[[self uuid] UUIDString] toDisk:YES];
    
    return self;
}

- (id)initWithImage:(UIImage *)image sender:(NSUUID *)sender senderName:(NSString *)name timestamp:(NSDate *)messageTimestamp uuid:(NSUUID *)uuid {
    if (!(self = [super initWithSender:sender senderName:name timestamp:messageTimestamp uuid:uuid]))
        return nil;
    
    NSData *imageData = UIImageJPEGRepresentation(self.image, 0.75);
    [[SDImageCache sharedImageCache] storeImage:image recalculateFromImage:YES imageData:imageData forKey:[[self uuid] UUIDString] toDisk:YES];
    
    return self;
}

- (UIImage *)image {
    // Slow? Maybe. But not too slow, and pretty easy.
    // It doesn't *always* fetch from disk.
    return [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[[self uuid] UUIDString]];
}

- (NSString *)bodytype {
    return @"jpeg";
}

-(NSMutableDictionary *)dictionaryDataRepresentation
{
    NSMutableDictionary *dict = [super dictionaryDataRepresentation];
    [dict setObject:self.bodytype forKey:@"body-type"];
    [dict setObject:UIImageJPEGRepresentation(self.image, 0.75) forKey:@"body"];
    
    return dict;
}

@end
