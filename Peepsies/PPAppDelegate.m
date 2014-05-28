//
//  PPAppDelegate.m
//  Peepsies
//
//  Created by Taldar Baddley on 2014-5-19.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import "PPAppDelegate.h" 
#import "PPMainAppViewController.h"
#import "DrawingViewController.h"
#import "PPPeers.h"
#import "PPUsernameViewController.h"

@implementation PPAppDelegate


+ (void)initialize {
    [[NSUserDefaults standardUserDefaults]
     registerDefaults:@{
                        @"PPDrawingLastBackgroundColor": @[ @1.0, @1.0, @1.0, @1.0 ],  // White
                        @"PPDrawingLastLineColor": @[ @0.0, @0.0, @0.0, @1.0 ],  // Black
                        @"PPDrawingLastLineWeight": @5.0
                        }];
}








- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UITabBarController *rootController = [[UITabBarController alloc] init];
    [rootController setViewControllers:@[
                                         [[UINavigationController alloc] initWithRootViewController:[[PPMainAppViewController alloc] init]]
                                         ]
                              animated:NO];
    self.window.rootViewController = rootController;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userWantsToMakeAPost:) name:@"PPNewPostNote" object:nil];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performLoginIfNecessary];
    });
    
    return YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}










- (void)userWantsToMakeAPost:(NSNotification *)note {
    [[[self window] rootViewController] presentViewController:[ [UINavigationController alloc]
                                                                initWithRootViewController: [[DrawingViewController alloc] init] ]
                                                     animated:YES
                                                   completion:nil];
}


- (void)userWantsToMakeATextPost:(NSNotification *)note {
    NSLog(@"Would make a text post.");
}





- (void)performLoginIfNecessary {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"PPUsername"]) {
        [PPPeers initSingleton];
        
    } else {
        [[[self window] rootViewController] presentViewController:[[PPUsernameViewController alloc] init]
                                                         animated:YES
                                                       completion:nil];
        
    }
    
    
    
}




@end
