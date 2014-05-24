//
//  DrawingAttributesViewController.m
//  Drawerator Extreme
//
//  Created by Taldar Baddley on 2014-5-18.
//  Copyright (c) 2014 Talus. All rights reserved.
//

#import "DrawingAttributesViewController.h"
#import "DLCPSaturationBrightnessPicker.h"
#import "DLCPHuePicker.h"
#import "NSUserDefaults+Colorific.h"

@interface DrawingAttributesViewController () {
    PPDrawingSettingsDoneBlock _doneBlock;
}

@end



@implementation DrawingAttributesViewController

- (id)initAndWhenDoneDo:(PPDrawingSettingsDoneBlock)doneBlock {
    
    if (! (self = [super initWithNibName:@"DrawingAttributesView" bundle:[NSBundle mainBundle]]) )
        return nil;
    
    NSUserDefaults *suds = [NSUserDefaults standardUserDefaults];
    _lineColor = [suds pp_colorForKey:@"PPDrawingLastLineColor"];
    _backgroundColor = [suds pp_colorForKey:@"PPDrawingLastBackgroundColor"];
    _weight = [suds doubleForKey:@"PPDrawingLastLineWeight"];
    _backgroundImage = nil;
    _doneBlock = [doneBlock copy];
    
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Drawing Tools"];
    
    [self updateSaturationBrightnessPicker:lineSaturationBrightnessPicker       andHuePicker:lineHuePicker       withColor:_lineColor];
    [self updateSaturationBrightnessPicker:backgroundSaturationBrightnessPicker andHuePicker:backgroundHuePicker withColor:_backgroundColor];
    
    [self swapLineAndBackgroundViews:nil];
    [lineWeightPicker setValue:_weight];
    
    
}



- (IBAction)swapLineAndBackgroundViews:(id)sender {
    NSArray *currentSubviews = [swapViewHolder subviews];
    
    if ([lineBackgroundChooser selectedSegmentIndex] == 0  &&  ![currentSubviews containsObject:linePickerView]) {
        for (UIView *spuriousView in currentSubviews)  [spuriousView removeFromSuperview];
        [swapViewHolder addSubview:linePickerView];
        [linePickerView setFrame:[swapViewHolder bounds]];
        
    } else if (![currentSubviews containsObject:backgroundPickerView]) {
        for (UIView *spuriousView in currentSubviews)  [spuriousView removeFromSuperview];
        [swapViewHolder addSubview:backgroundPickerView];
        [backgroundPickerView setFrame:[swapViewHolder bounds]];
        
    } // otherwise we're already set.
    
}



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_doneBlock)
        _doneBlock();
}



- (void)updateSaturationBrightnessPicker:(DLCPSaturationBrightnessPicker *)sbPicker
                            andHuePicker:(DLCPHuePicker *)huePicker
                               withColor:(UIColor *)newColor {
    
    CGFloat hue, saturation, brightness, alpha;
    
    [newColor getHue:&hue
          saturation:&saturation
          brightness:&brightness
               alpha:&alpha];
    
    [sbPicker setSaturation:saturation brightness:brightness];
    [sbPicker setVisualHue:hue];
    [huePicker setHue:hue];
    
}


- (IBAction)userDidSelectNewLineSaturationAndBrightness:(id)sender {
    _lineColor = [[UIColor alloc] initWithHue:[lineHuePicker hue]
                                   saturation:[lineSaturationBrightnessPicker saturation]
                                   brightness:[lineSaturationBrightnessPicker brightness]
                                        alpha:1];
    [self updateSaturationBrightnessPicker:nil andHuePicker:lineHuePicker withColor:_lineColor];
    [[NSUserDefaults standardUserDefaults] pp_setColor:_lineColor forKey:@"PPDrawingLastLineColor"];
}


- (IBAction)userDidSelectNewLineHue:(id)sender {
    _lineColor = [[UIColor alloc] initWithHue:[lineHuePicker hue]
                                   saturation:[lineSaturationBrightnessPicker saturation]
                                   brightness:[lineSaturationBrightnessPicker brightness]
                                        alpha:1];
    [self updateSaturationBrightnessPicker:lineSaturationBrightnessPicker andHuePicker:nil withColor:_lineColor];
    [[NSUserDefaults standardUserDefaults] pp_setColor:_lineColor forKey:@"PPDrawingLastLineColor"];
}


- (IBAction)userDidSelectNewBackgroundSaturationAndBrightness:(id)sender {
    _backgroundColor = [[UIColor alloc] initWithHue:[backgroundHuePicker hue]
                                 saturation:[backgroundSaturationBrightnessPicker saturation]
                                 brightness:[backgroundSaturationBrightnessPicker brightness]
                                      alpha:1];
    [self updateSaturationBrightnessPicker:nil andHuePicker:backgroundHuePicker withColor:_backgroundColor];
    [[NSUserDefaults standardUserDefaults] pp_setColor:_backgroundColor forKey:@"PPDrawingLastBackgroundColor"];
}


- (IBAction)userDidSelectNewBackgroundHue:(id)sender {
    _backgroundColor = [[UIColor alloc] initWithHue:[backgroundHuePicker hue]
                                 saturation:[backgroundSaturationBrightnessPicker saturation]
                                 brightness:[backgroundSaturationBrightnessPicker brightness]
                                      alpha:1];
    [self updateSaturationBrightnessPicker:backgroundSaturationBrightnessPicker andHuePicker:nil withColor:_backgroundColor];
    [[NSUserDefaults standardUserDefaults] pp_setColor:_backgroundColor forKey:@"PPDrawingLastBackgroundColor"];
}


- (IBAction)userDidSelectNewLineWeight:(id)sender {
    _weight = [lineWeightPicker value];
    [[NSUserDefaults standardUserDefaults] setDouble:_weight forKey:@"PPDrawingLastLineWeight"];
}



- (IBAction)userWantsANewBackgroundPicture:(id)sender {
    NSLog(@"Selectafoto");
}



@end
