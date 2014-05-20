//
//  DrawingAttributesViewController.h
//  Drawerator Extreme
//
//  Created by Taldar Baddley on 2014-5-18.
//  Copyright (c) 2014 Talus. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DLCPSaturationBrightnessPicker;
@class DLCPHuePicker;

typedef void (^PPDrawingSettingsDoneBlock)(UIColor *lineColor, UIColor *bgColor, CGFloat lineWeight, UIImage *bgImage);


@interface DrawingAttributesViewController : UIViewController {
    __weak IBOutlet UISegmentedControl *lineBackgroundChooser;
    __weak IBOutlet UIView *swapViewHolder;
    
    IBOutlet UIView *linePickerView;
    __weak IBOutlet DLCPSaturationBrightnessPicker *lineSaturationBrightnessPicker;
    __weak IBOutlet DLCPHuePicker *lineHuePicker;
    __weak IBOutlet UISlider *lineWeightPicker;
    
    IBOutlet UIView *backgroundPickerView;
    __weak IBOutlet DLCPSaturationBrightnessPicker *backgroundSaturationBrightnessPicker;
    __weak IBOutlet DLCPHuePicker *backgroundHuePicker;
    __weak IBOutlet UIButton *backgroundImageChooserButton;
}

- (id)initWithStartingLineColor:(UIColor *)lineColor
                backgroundColor:(UIColor *)bgColor
                     lineWeight:(CGFloat)weight
                backgroundImage:(UIImage *)bgImage
                     whenDoneDo:(PPDrawingSettingsDoneBlock)doneBlock;

@property (nonatomic, readonly) UIColor *lineColor;
@property (nonatomic, readonly) UIColor *backgroundColor;
@property (nonatomic, readonly) CGFloat weight;
@property (nonatomic, readonly) UIImage *backgroundImage;


@end
