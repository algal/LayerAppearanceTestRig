//
//  ViewController.h
//  test
//
//  Created by Alexis Gallagher on 2012-11-12.
//  Copyright (c) 2012 Foxtrot Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISwitch *switchMasksToBounds;
@property (weak, nonatomic) IBOutlet UISwitch *switchCornerRadius;
@property (weak, nonatomic) IBOutlet UISwitch *switchMask;
@property (weak, nonatomic) IBOutlet UISwitch *switchOpaque;
@property (weak, nonatomic) IBOutlet UISwitch *switchShadowOpacity;
@property (weak, nonatomic) IBOutlet UISwitch *switchShadowPath;

- (IBAction)switchValueChanged:(id)sender;

- (IBAction)handleClickSetNeedsDisplay:(id)sender;
@end
