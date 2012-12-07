//
//  ViewController.h
//  test
//
//  Created by Alexis Gallagher on 2012-11-12.
//  Copyright (c) 2012 Foxtrot Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

// layer controls

@property (weak, nonatomic) IBOutlet UISwitch * switchMasksToBounds;
@property (weak, nonatomic) IBOutlet UISwitch * switchMask;
@property (weak, nonatomic) IBOutlet UISwitch * switchLayerOpaque;
@property (weak, nonatomic) IBOutlet UISlider * sliderCornerRadius;
@property (weak, nonatomic) IBOutlet UISlider * sliderShadowOpacity;
@property (weak, nonatomic) IBOutlet UISwitch * switchShadowPath;
@property (weak, nonatomic) IBOutlet UISlider * sliderLayerOpacity;

// handelers

- (IBAction)switchValueChanged:(id)sender;
- (IBAction)handleClickSetNeedsDisplay:(id)sender;

// labels

@property (weak, nonatomic) IBOutlet UILabel * labelViewClipsToBounds;
@property (weak, nonatomic) IBOutlet UILabel * labelViewOpaque;
@property (weak, nonatomic) IBOutlet UILabel * labelViewAlpha;
@property (weak, nonatomic) IBOutlet UILabel * labelLayerBackground;
@property (weak, nonatomic) IBOutlet UILabel * labelViewBackground;
@property (weak, nonatomic) IBOutlet UILabel * labelLayerShadowOpacity;
@property (weak, nonatomic) IBOutlet UILabel * labelLayerCornerRadius;

@end
