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

@interface DrawingAttributesViewController () {
    PPDrawingSettingsDoneBlock _doneBlock;
}

@end



@implementation DrawingAttributesViewController

- (id)initWithStartingLineColor:(UIColor *)lineColor
                backgroundColor:(UIColor *)bgColor
                     lineWeight:(CGFloat)weight
                backgroundImage:(UIImage *)bgImage
                     whenDoneDo:(PPDrawingSettingsDoneBlock)doneBlock {
    
    if (! (self = [super initWithNibName:@"DrawingAttributesView" bundle:[NSBundle mainBundle]]) )
        return nil;
    
    _lineColor = lineColor;
    _backgroundColor = bgColor;
    _weight = weight;
    _backgroundImage = bgImage;
    _doneBlock = [doneBlock copy];
    
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Drawing Tools"];
    
    [self updateSaturationBrightnessPicker:lineSaturationBrightnessPicker       andHuePicker:lineHuePicker       withColor:_lineColor];
    [self updateSaturationBrightnessPicker:backgroundSaturationBrightnessPicker andHuePicker:backgroundHuePicker withColor:_backgroundColor];
    
    [self swapLineAndBackgroundViews];
    [lineWeightPicker setValue:_weight];
    
    [lineBackgroundChooser                addTarget:self
                                             action:@selector(swapLineAndBackgroundViews)
                                   forControlEvents:UIControlEventValueChanged];
    
    [lineSaturationBrightnessPicker       addTarget:self
                                             action:@selector(userDidSelectNewLineSaturationAndBrightness)
                                   forControlEvents:UIControlEventValueChanged];
    
    [lineHuePicker                        addTarget:self
                                             action:@selector(userDidSelectNewLineHue)
                                   forControlEvents:UIControlEventValueChanged];
    
    [backgroundSaturationBrightnessPicker addTarget:self
                                             action:@selector(userDidSelectNewBackgroundSaturationAndBrightness)
                                   forControlEvents:UIControlEventValueChanged];
    
    [backgroundHuePicker                  addTarget:self
                                             action:@selector(userDidSelectNewBackgroundHue)
                                   forControlEvents:UIControlEventValueChanged];
    
    [lineWeightPicker                     addTarget:self
                                             action:@selector(userDidSelectNewLineWeight)
                                   forControlEvents:UIControlEventValueChanged];
    
    [backgroundImageChooserButton         addTarget:self
                                             action:@selector(userWantsANewBackgroundPicture)
                                   forControlEvents:UIControlEventTouchUpInside];
    
    
}



- (void)swapLineAndBackgroundViews {
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
    _doneBlock(_lineColor, _backgroundColor, _weight, _backgroundImage);
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


- (void)userDidSelectNewLineSaturationAndBrightness {
    _lineColor = [[UIColor alloc] initWithHue:[lineHuePicker hue]
                                   saturation:[lineSaturationBrightnessPicker saturation]
                                   brightness:[lineSaturationBrightnessPicker brightness]
                                        alpha:1];
    [self updateSaturationBrightnessPicker:nil andHuePicker:lineHuePicker withColor:_lineColor];
}


- (void)userDidSelectNewLineHue {
    _lineColor = [[UIColor alloc] initWithHue:[lineHuePicker hue]
                                   saturation:[lineSaturationBrightnessPicker saturation]
                                   brightness:[lineSaturationBrightnessPicker brightness]
                                        alpha:1];
    [self updateSaturationBrightnessPicker:lineSaturationBrightnessPicker andHuePicker:nil withColor:_lineColor];
}


- (void)userDidSelectNewBackgroundSaturationAndBrightness {
    _backgroundColor = [[UIColor alloc] initWithHue:[backgroundHuePicker hue]
                                 saturation:[backgroundSaturationBrightnessPicker saturation]
                                 brightness:[backgroundSaturationBrightnessPicker brightness]
                                      alpha:1];
    [self updateSaturationBrightnessPicker:nil andHuePicker:backgroundHuePicker withColor:_backgroundColor];
}


- (void)userDidSelectNewBackgroundHue {
    _backgroundColor = [[UIColor alloc] initWithHue:[backgroundHuePicker hue]
                                 saturation:[backgroundSaturationBrightnessPicker saturation]
                                 brightness:[backgroundSaturationBrightnessPicker brightness]
                                      alpha:1];
    [self updateSaturationBrightnessPicker:backgroundSaturationBrightnessPicker andHuePicker:nil withColor:_backgroundColor];
}


- (void)userDidSelectNewLineWeight {
    _weight = [lineWeightPicker value];
}



- (void)userWantsANewBackgroundPicture {
    NSLog(@"Selectafoto");
}



@end
