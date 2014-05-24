//
//  NSUserDefaults+Colorific.h
//  Peepsies
//
//  Created by Taldar Baddley on 2014-5-23.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSUserDefaults (Colorific)

- (void)pp_setColor:(UIColor *)aColor forKey:(NSString *)keey;
- (UIColor *)pp_colorForKey:(NSString *)keey;

@end
