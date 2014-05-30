//
//  PPUsernameViewController.m
//  Peepsies
//
//  Created by Taldar Baddley on 2014-5-26.
//  Copyright (c) 2014 Peepsies Ltd. All rights reserved.
//

#import "PPUsernameViewController.h"
#import "PPPeers.h"

@interface PPUsernameViewController () {
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UILabel *namelongIndicator;
    __weak IBOutlet UIButton *loginButton;
}



@end



@implementation PPUsernameViewController

- (id)init {
    self = [super initWithNibName:@"PPUsernameView" bundle:[NSBundle mainBundle]];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}




- (IBAction)userUpdatedName:(id)sender {
    // Bonjour names cannot be longer than 63 bytes (UTF-8 assumed).
    
    if ([[nameField text] lengthOfBytesUsingEncoding:NSUTF8StringEncoding] > 63) {
        [namelongIndicator setHidden:NO];
        [loginButton setEnabled:NO];
        
    } else {
        [namelongIndicator setHidden:YES];
        [loginButton setEnabled: ([[nameField text] length] > 0) ];
        
    }
    
}


- (IBAction)userCommitName:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:[nameField text]
                                              forKey:@"PPUsername"];
    [[NSUserDefaults standardUserDefaults] setObject:[[NSUUID UUID] UUIDString]
                                              forKey:@"PPUserUUID"];
    [PPPeers initSingleton];
    
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}



@end
