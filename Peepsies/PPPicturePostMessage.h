//
//  PPPicturePostMessage.h
//  Peepsies
//
//  Created by Taldar Baddley on 2014-5-27.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import "PPPostMessage.h"

@interface PPPicturePostMessage : PPPostMessage

- (id)initWithJPEGData:(NSData *)imageData sender:(NSUUID *)sender senderName:(NSString *)name timestamp:(NSDate *)messageTimestamp uuid:(NSUUID *)uuid;
- (id)initWithImage:(UIImage *)image sender:(NSUUID *)sender senderName:(NSString *)name timestamp:(NSDate *)messageTimestamp uuid:(NSUUID *)uuid;
@property (nonatomic, readonly) UIImage *image;

@end
