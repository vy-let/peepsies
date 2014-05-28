//
//  PPPicturePostMessage.h
//  Peepsies
//
//  Created by Taldar Baddley on 2014-5-27.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import "PPPostMessage.h"

@interface PPPicturePostMessage : PPPostMessage

- (id)initWithImage:(UIImage *)image imageData:(NSData *)imageDataOrNil sender:(NSUUID *)sender senderName:(NSString *)name;
@property (nonatomic, readonly) UIImage *image;

@end
