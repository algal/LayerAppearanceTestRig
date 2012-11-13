//
//  ViewController.m
//  test
//
//  Created by Alexis Gallagher on 2012-11-12.
//  Copyright (c) 2012 Foxtrot Studios. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"

@interface ViewController ()
@property (weak) UIView * theView;
@end

@implementation ViewController

- (UIView *)roundedImage
{
	// Do any additional setup after loading the view, typically from a nib.
    
    UIImage *image = [UIImage imageNamed:@"mandel_images.png"];
    
    CGRect imgFrame = CGRectMake(100, 100, 100, 100);
    UIView *imgView = [[UIView alloc] initWithFrame:imgFrame];
    imgView.backgroundColor = [UIColor colorWithPatternImage:image];
    
    // Rounded corners.
    imgView.layer.cornerRadius = 10;
    
    // A thin border.
    imgView.layer.borderColor = [UIColor blackColor].CGColor;
    imgView.layer.borderWidth = 0.3;
    
    // Drop shadow.
    imgView.layer.shadowColor = [UIColor blackColor].CGColor;
    imgView.layer.shadowOpacity = 1.0;
    imgView.layer.shadowRadius = 7.0;
    imgView.layer.shadowOffset = CGSizeMake(0, 4);
    return imgView;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor lightGrayColor];
  
  UIView * hostView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
  [self.view addSubview:hostView];
  self.theView = hostView;
  
}

-(void)updateLayerFromSwitches
{
  CALayer * hostLayer = self.theView.layer;
  
  CGFloat const CORNER_RADIUS = 20.f;
  
  // update
  hostLayer.masksToBounds = self.switchMasksToBounds.on;
  hostLayer.cornerRadius = self.switchCornerRadius.on ? CORNER_RADIUS : 0.0f;
  hostLayer.opaque = self.switchOpaque.on;
  hostLayer.shadowRadius = 10.f;
  hostLayer.shadowOpacity = self.switchShadowOpacity.on ? 0.5f : 0.0f;
  hostLayer.shadowPath = self.switchShadowPath.on ?
  [[UIBezierPath bezierPathWithRoundedRect:hostLayer.bounds
                              cornerRadius:CORNER_RADIUS] CGPath] :  nil;
  
  // configure background
  hostLayer.backgroundColor = [[UIColor blueColor] CGColor];
  
  // purge any sublayers
  [hostLayer.sublayers enumerateObjectsUsingBlock:
   ^(CALayer * sublayer, NSUInteger idx, BOOL *stop) {
     [sublayer removeFromSuperlayer];
   }];
  
  // add a circle sublayer
  CAShapeLayer * circleLayer = [[CAShapeLayer alloc] init];
  circleLayer.bounds = CGRectMake(0, 0, 150, 150); // bigger than container
  circleLayer.position = CGPointMake(CGRectGetMaxX(hostLayer.bounds), // centered on right
                                     CGRectGetMidY(hostLayer.bounds));
  circleLayer.path = [[UIBezierPath bezierPathWithRoundedRect:circleLayer.bounds
                                                 cornerRadius:circleLayer.bounds.size.width / 2.0] CGPath];
  circleLayer.fillColor = [[UIColor redColor] CGColor];
  [hostLayer addSublayer:circleLayer];
}


- (IBAction)switchValueChanged:(id)sender {
  [self updateLayerFromSwitches];
}

- (IBAction)handleClickSetNeedsDisplay:(id)sender {
  CALayer * hostLayer = self.theView.layer;
  [hostLayer setNeedsDisplay];
}
@end
