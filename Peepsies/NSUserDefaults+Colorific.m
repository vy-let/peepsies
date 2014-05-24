//
//  NSUserDefaults+Colorific.m
//  Peepsies
//
//  Created by Taldar Baddley on 2014-5-23.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import "NSUserDefaults+Colorific.h"

@implementation NSUserDefaults (Colorific)


- (void)pp_setColor:(UIColor *)aColor forKey:(NSString *)keey {
    CGFloat desiredRed, desiredGreen, desiredBlue, desiredAlpha;
    [aColor getRed:&desiredRed
             green:&desiredGreen
              blue:&desiredBlue
             alpha:&desiredAlpha];
    
    [self setObject:@[[NSNumber numberWithDouble:desiredRed],
                      [NSNumber numberWithDouble:desiredGreen],
                      [NSNumber numberWithDouble:desiredBlue],
                      [NSNumber numberWithDouble:desiredAlpha]
                      
                      ] forKey:keey];
}



- (UIColor *)pp_colorForKey:(NSString *)keey {
    NSArray *desiredColor = [self objectForKey:keey];
    if (![desiredColor respondsToSelector:@selector(objectAtIndex:)]
        ||  ![desiredColor respondsToSelector:@selector(count)]
        ||  [desiredColor count] != 4)
        return nil;
    
    CGFloat redValue = [[desiredColor objectAtIndex:0] doubleValue];
    CGFloat greenValue = [[desiredColor objectAtIndex:1] doubleValue];
    CGFloat blueValue = [[desiredColor objectAtIndex:2] doubleValue];
    CGFloat alphaValue = [[desiredColor objectAtIndex:3] doubleValue];
    
    return [UIColor colorWithRed:redValue green:greenValue blue:blueValue alpha:alphaValue];
}



@end
