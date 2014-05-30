//
//  DrawingViewController.m
//  Drawerator Extreme
//
//  Created by Taldar Baddley on 2014-5-18.
//  Copyright (c) 2014 Talus. All rights reserved.
//

#import "DrawingViewController.h"
#import "PPDrawView.h"
#import "PPPeers.h"
#import "PPPicturePostMessage.h"
#import "PPDrawingRecordView.h"
#import "DrawingAttributesViewController.h"
#import "NSUserDefaults+Colorific.h"
#import "MAKVONotificationCenter.h"

@interface DrawingViewController ()

@property (nonatomic, weak) PPDrawView *drawingView;
@property (nonatomic, weak) PPDrawingRecordView *drawingRecordView;
@property (nonatomic, weak) UIBarButtonItem *cancelDrawingButton;
@property (nonatomic) UIImage *currentBgImage;

@end



@implementation DrawingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Drawing"];
    
    NSUserDefaults *suds = [NSUserDefaults standardUserDefaults];
    [[self view] setBackgroundColor:[suds pp_colorForKey:@"PPDrawingLastBackgroundColor"]];
    
    CGRect navBarFrame = [[[self navigationController] navigationBar] frame];
    CGRect myBounds = [[self view] bounds];
    CGRect drawingFrame = myBounds;
    drawingFrame.origin.y = navBarFrame.size.height + navBarFrame.origin.y;
    drawingFrame.size.height -= (navBarFrame.size.height + navBarFrame.origin.y);
    
    PPDrawingRecordView *recordView = [[PPDrawingRecordView alloc] initWithFrame:drawingFrame];
    [[self view] addSubview:recordView];
    _drawingRecordView = recordView;
    
    PPDrawView *drawingView = [[PPDrawView alloc] initWithFrame:drawingFrame];
    [drawingView setTouchEndedTarget:self action:@selector(finishedStroke:)];
    [[self view] addSubview:drawingView];
    _drawingView = drawingView;
    [self setUpDrawingView];
    [self listeningForDrawingAttributeChanges];
    
    [self setUpTitleBar];
}



- (void)setUpDrawingView {
    NSUserDefaults *suds = [NSUserDefaults standardUserDefaults];
    [_drawingView setStrokeColor:[suds pp_colorForKey:@"PPDrawingLastLineColor"]];
    [_drawingView setStrokeWidth:[suds doubleForKey:@"PPDrawingLastLineWeight"]];
    [_drawingView setOpaque:NO];
    [_drawingView setBackgroundColor:[UIColor colorWithWhite:1 alpha:0]];
    [_drawingView setCanEdit:YES];
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



- (void)listeningForDrawingAttributeChanges {
    // The KVO Center retains, as it must, the observation blocks below.
    // If they were to refer directly to self, or to self's iVars, the drawing view would never,
    // ever get dealloc'ed. It's not the usual retain cycle issue, but the resolution is the same weak-self dance.
    // See: https://www.mikeash.com/pyblog/friday-qa-2012-03-02-key-value-observing-done-right-take-2.html#comment-9d1c74918104a9892b19603ab9ea01ee
    __weak DrawingViewController *weakSelf = self;
    
    // Totally doesn't need to be weak, because it lasts the lifetime of the app anyhow.
    // But the compiler whines otherwise.
    __weak NSUserDefaults *suds = [NSUserDefaults standardUserDefaults];
    
    [suds addObservationKeyPath:@"PPDrawingLastLineWeight" options:NSKeyValueObservingOptionNew block:^(MAKVONotification *notification) {
        [[weakSelf drawingView] setStrokeWidth:[[notification newValue] doubleValue]];
    }];
    
    [suds addObservationKeyPath:@"PPDrawingLastLineColor" options:NSKeyValueObservingOptionNew block:^(MAKVONotification *notification) {
        [[weakSelf drawingView] setStrokeColor:[suds pp_colorForKey:@"PPDrawingLastLineColor"]];  // We could use the new value from the notification, but it doesn't give us this helper method.
    }];
    
    [suds addObservationKeyPath:@"PPDrawingLastBackgroundColor" options:NSKeyValueObservingOptionNew block:^(MAKVONotification *notification) {
        [[weakSelf view] setBackgroundColor:[suds pp_colorForKey:@"PPDrawingLastBackgroundColor"]];
    }];
    
}





- (IBAction)finishedStroke:(id)sender {
    UIBezierPath *lastStroke = [_drawingView bezierPathRepresentation];
    if (!lastStroke) return;
    
    [_drawingRecordView pushStroke:lastStroke
                            weight:[_drawingView strokeWidth]
                             color:[_drawingView strokeColor]];
    [_drawingView clearDrawing];
    [self setUpDrawingView];
    
    return;
}





- (void)postPicture {
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:^{
        
        UIImage *newDrawing = [_drawingRecordView imageWithBackgroundColor:[[self view] backgroundColor]];
        NSUUID *myUUID = [[NSUUID alloc] initWithUUIDString:[[NSUserDefaults standardUserDefaults] objectForKey:@"PPUserUUID"]];
        PPPicturePostMessage *post = [[PPPicturePostMessage alloc] initWithImage:newDrawing
                                                                          sender:myUUID
                                                                      senderName:[[NSUserDefaults standardUserDefaults] objectForKey:@"PPUsername"]
                                                                       timestamp:nil
                                                                            uuid:nil];
        [[PPPeers peers] broadcastMessage:post];
        
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
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
        
    }
}




- (void)editDrawingAttributes {
    DrawingAttributesViewController *attrsVC =
    [[DrawingAttributesViewController alloc] initAndWhenDoneDo:^{
        // do we need this?
    }];
    
    // Do this when we have time to figure out how to make it work:
//    [UIView transitionWithView:[[self navigationController] view] duration:0.75 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
//        [[self navigationController] pushViewController:attrsVC animated:YES];
//    } completion:nil];
    [[self navigationController] pushViewController:attrsVC animated:YES];
}





@end
