//
//  PPAppDelegate.h
//  Peepsies
//
//  Created by Taldar Baddley on 2014-5-19.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPAppDelegate : UIResponder <UIApplicationDelegate>

- (void)userWantsToMakeAPost:(NSNotification *)note;
- (void)userWantsToMakeATextPost:(NSNotification *)note;

@property (strong, nonatomic) UIWindow *window;

@end
