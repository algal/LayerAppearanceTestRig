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
  
  [self updateLayerFromSwitches];
  [self updateLabels];
}

-(void)updateLayerFromSwitches
{
  CALayer * hostLayer = self.theView.layer;
  
  // BUILD THE LAYER from scratch
  // configure background
  hostLayer.backgroundColor = [[UIColor blueColor] CGColor];
  
  // purge any sublayers
  hostLayer.mask = nil;
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
  
  // add a mask sublayer
  CAShapeLayer * ellipseLayer = [[CAShapeLayer alloc] init];
  CGFloat insetAmount = hostLayer.bounds.size.height * 0.25f;
  ellipseLayer.bounds = UIEdgeInsetsInsetRect(hostLayer.bounds,
                                              UIEdgeInsetsMake(insetAmount, insetAmount, insetAmount, insetAmount));
  ellipseLayer.position = CGPointMake(CGRectGetMidX(hostLayer.bounds), // centered
                                      CGRectGetMidY(hostLayer.bounds));
  ellipseLayer.path = [[UIBezierPath bezierPathWithRoundedRect:ellipseLayer.bounds
                                                  cornerRadius:ellipseLayer.bounds.size.width / 2.0] CGPath];
  ellipseLayer.fillColor = [[UIColor whiteColor] CGColor];

  // CONFIGURE THE LAYER FROM SWITCHES
  
  
  CGFloat const CORNER_RADIUS = 20.f;
  
  // update
  hostLayer.masksToBounds = self.switchMasksToBounds.on;
  hostLayer.cornerRadius = self.switchCornerRadius.on ? CORNER_RADIUS : 0.0f;
  hostLayer.mask = self.switchMask.on ? ellipseLayer : nil;
  hostLayer.opaque = self.switchOpaque.on;
  hostLayer.shadowRadius = 10.f;
  hostLayer.shadowOpacity = self.switchShadowOpacity.on ? 0.5f : 0.0f;
  hostLayer.shadowPath = self.switchShadowPath.on ?
  [[UIBezierPath bezierPathWithRoundedRect:hostLayer.bounds
                              cornerRadius:CORNER_RADIUS] CGPath] :  nil;
}


- (IBAction)switchValueChanged:(id)sender {
  [self updateLayerFromSwitches];
  [self updateLabels];
}

- (IBAction)handleClickSetNeedsDisplay:(id)sender {
  CALayer * hostLayer = self.theView.layer;
  [hostLayer setNeedsDisplay];
  [self updateLabels];
}

-(void)updateLabels
{
  self.labelViewOpaque.text = self.theView.opaque ? @"YES" : @"NO";
  self.labelViewClipsToBounds.text = self.theView.clipsToBounds ? @"YES" : @"NO";
  [self.labelViewOpaque setNeedsDisplay];
  [self.labelViewClipsToBounds setNeedsDisplay];
}
@end
