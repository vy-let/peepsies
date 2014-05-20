//
//  DrawingViewController.m
//  Drawerator Extreme
//
//  Created by Taldar Baddley on 2014-5-18.
//  Copyright (c) 2014 Talus. All rights reserved.
//

#import "DrawingViewController.h"
#import "DrawView.h"
#import "DrawingAttributesViewController.h"

@interface DrawingViewController () {
    __weak DrawView *_drawingView;
    __weak UIBarButtonItem *_cancelDrawingButton;
    UIImage *_currentBgImage;
}

@end



@implementation DrawingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Drawing"];
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
    CGRect navBarFrame = [[[self navigationController] navigationBar] frame];
    CGRect myBounds = [[self view] bounds];
    CGRect drawingFrame = myBounds;
    drawingFrame.origin.y = navBarFrame.size.height + navBarFrame.origin.y;
    drawingFrame.size.height -= (navBarFrame.size.height + navBarFrame.origin.y);
    
    DrawView *drawingView = [[DrawView alloc] initWithFrame:drawingFrame];
    [drawingView setStrokeWidth:3];
    [drawingView setStrokeColor:[UIColor blackColor]];
    [drawingView setOpaque:NO];
    [drawingView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0]];
    
    [[self view] addSubview:drawingView];
    [drawingView setCanEdit:YES];
    
    [self setUpTitleBar];
    
    _drawingView = drawingView;
}

- (void)setUpTitleBar {
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] initWithTitle:@"Post"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(postPicture)];
    
    UIBarButtonItem *toolsButton = [[UIBarButtonItem alloc] initWithTitle:@"  ⚙  "
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(editDrawingAttributes)];
    [toolsButton setTitleTextAttributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:22] }
                               forState:UIControlStateNormal];
    
    [[self navigationItem] setRightBarButtonItems:@[postButton, toolsButton]];
    
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                  target:self
                                                                                  action:@selector(potentiallyCancelOutDrawing)];
    [[self navigationItem] setLeftBarButtonItem:cancelButton];
    _cancelDrawingButton = cancelButton;
}




- (void)postPicture {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Would post drawing now.");
    }];
}



- (void)potentiallyCancelOutDrawing {
    UIActionSheet *canceller = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to discard this drawing?"
                                                           delegate:self
                                                  cancelButtonTitle:@"Keep Drawing"
                                             destructiveButtonTitle:@"Don’t Save"
                                                  otherButtonTitles:nil];
    [canceller showFromBarButtonItem:_cancelDrawingButton animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [actionSheet destructiveButtonIndex]) {
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:^{ }];
        
    }
}




- (void)editDrawingAttributes {
    DrawingAttributesViewController *attrsVC =
    [[DrawingAttributesViewController alloc] initWithStartingLineColor:[_drawingView strokeColor] backgroundColor:[[self view] backgroundColor] lineWeight:[_drawingView strokeWidth] backgroundImage:_currentBgImage whenDoneDo:
     ^(UIColor *newLineColor, UIColor *newBgColor, CGFloat newLineWeight, UIImage *newBgImage) {
        
         [_drawingView setStrokeColor:newLineColor];
         [[self view] setBackgroundColor:newBgColor];
         [_drawingView setStrokeWidth:newLineWeight];
         _currentBgImage = newBgImage;  // TODO set this up properly, of course.
         [_drawingView setCanEdit:YES];
    }];
    
    [[self navigationController] pushViewController:attrsVC animated:YES];
}





@end
