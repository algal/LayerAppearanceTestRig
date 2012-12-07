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
  self.view.backgroundColor = [UIColor whiteColor];
  
  UIView * hostView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 200, 200)];
  [self.view addSubview:hostView];
  self.theView = hostView;
  
  [self updateLayerFromControls];
  [self updateLabels];
}

-(void)updateLayerFromControls
{
  CALayer * hostLayer = self.theView.layer;

  //
  // BUILD THE LAYER from scratch
  //
  
  // purge any masks, sublayers, transforms
  hostLayer.mask = nil;
  [hostLayer.sublayers enumerateObjectsUsingBlock:
   ^(CALayer * sublayer, NSUInteger idx, BOOL *stop) {
     [sublayer removeFromSuperlayer];
   }];
  NSLog(@"CGAffineTransformIdentity=%@",NSStringFromCGAffineTransform(CGAffineTransformIdentity));
  NSLog(@"hostLayer.transform=%@",NSStringFromCGAffineTransform(CATransform3DGetAffineTransform(hostLayer.transform)));
  NSLog(@"hostLayer.sublayerTransform=%@",NSStringFromCGAffineTransform(CATransform3DGetAffineTransform(hostLayer.sublayerTransform)));
  NSLog(@"hostLayer.contentsAreFlipped=%@",(hostLayer.contentsAreFlipped ? @"YES" : @"NO"));
  hostLayer.transform = CATransform3DIdentity;
  hostLayer.sublayerTransform = CATransform3DIdentity;
  
  // assign image to backgroundColor
   hostLayer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"mandel200x200.jpg"]].CGColor;
  /*
   This transform ensures that the image provided as a background color appears correctly oriented;
   otherwise, it appears flipped along the y-axis.
   
   Why? Not 100% sure. CoreGraphics normally use a flipped coordinate system but UIKit normally
   compensates for this so you don't notice. However, this compensation seems to apply to a 
   CALayer's contents (i.e., foreground), not to its background, so we need to add this transform 
   explicitly to ensure that images added via the backgroundColor are oriented correctly.
   
   In what sense does iOS normally compensate for the reversed coordinates. For instance, if you 
   assign an image to the _contents_ of the layer with the statement
     hostLayer.contents = (id) [UIImage imageNamed:@"mandel200x200.jpg"] CGImage];
   then the image appears with the correct orientation.
   
   So why  not do that? If you assign the image to the contents of the layer, then it only receives 
   the corner-clipping produced by the cornerRadius property if you ALSO turn on masksToBounds, and 
   if you turn on masksToBounds then you also clip out any drop shadow produced by shadowOpacity. 
   So if you want rounded corners AND a drop shadow AND you want to do it all with one layer, then
   you need to put the image in the background.
   
   Alternatively, you can produce the same visual effect by using multiple layers: a bottom layer
   with masksToBounds=NO which produces the drop shadow (with contours implicitly defined from a 
   .cornerRadius or else explicitly defined with .shadowPath), and then a sublayer layer on top 
   with masksToBounds=YES and the image in its .contents and then a cornerRadius (or even
   a .mask) defining that defines identical clipping of the corners.
   */
  hostLayer.transform = CATransform3DMakeScale(1.0f, -1.0f, 1.0f);
  /*
   This .sublayerTransform ensures that the transform above, which we introduced to correct the
   orientation of images in the backGroundcolor, does not apply to sublayers as well.
   */
  hostLayer.sublayerTransform = CATransform3DMakeScale(1.0f, -1.0f, 1.0f);
  
  // add a circle sublayer
  CAShapeLayer * circleLayer = [[CAShapeLayer alloc] init];
  circleLayer.bounds = CGRectMake(0, 0, 150, 150);
  circleLayer.position = CGPointMake(CGRectGetMaxX(hostLayer.bounds), // centered on bottom-right
                                     CGRectGetMaxY(hostLayer.bounds));
  circleLayer.path = [[UIBezierPath bezierPathWithRoundedRect:circleLayer.bounds
                                                 cornerRadius:circleLayer.bounds.size.width / 2.0] CGPath];
  circleLayer.fillColor = [[UIColor magentaColor] CGColor];
  [hostLayer addSublayer:circleLayer];
  
  // add a mask sublayer
  CAShapeLayer * ellipseLayer = [[CAShapeLayer alloc] init];
  CGFloat insetAmount = hostLayer.bounds.size.height * 0.25f; // smaller than host
  ellipseLayer.bounds = UIEdgeInsetsInsetRect(hostLayer.bounds,
                                              UIEdgeInsetsMake(insetAmount, insetAmount, insetAmount, insetAmount));
  ellipseLayer.position = CGPointMake(CGRectGetMidX(hostLayer.bounds), // centered
                                      CGRectGetMidY(hostLayer.bounds));
  ellipseLayer.path = [[UIBezierPath bezierPathWithRoundedRect:ellipseLayer.bounds
                                                  cornerRadius:ellipseLayer.bounds.size.width / 2.0] CGPath];
  ellipseLayer.fillColor = [[UIColor whiteColor] CGColor]; // any color will provide non-zero alpha
  
  //
  // CONFIGURE THE LAYER FROM THE CONTROLS
  //
  
  CGFloat const CORNER_RADIUS = self.sliderCornerRadius.value;
  hostLayer.opacity = self.sliderLayerOpacity.value;
  NSLog(@"hostLayer.opacity=%f",hostLayer.opacity);
  NSLog(@"view.alpha=%f",self.theView.alpha);
  hostLayer.masksToBounds = self.switchMasksToBounds.on;
  hostLayer.cornerRadius =  CORNER_RADIUS;
  hostLayer.mask = self.switchMask.on ? ellipseLayer : nil;
  hostLayer.opaque = self.switchLayerOpaque.on;
  hostLayer.shadowRadius = 10.f;
  hostLayer.shadowOpacity = self.sliderShadowOpacity.value;
  hostLayer.shouldRasterize = self.switchLayerShouldRasterize.on;
  hostLayer.shadowPath = self.switchShadowPath.on ?
  [[UIBezierPath bezierPathWithRoundedRect:hostLayer.bounds
                              cornerRadius:CORNER_RADIUS] CGPath] :  nil;
}

- (IBAction)switchValueChanged:(id)sender {
  [self updateLayerFromControls];
  [self updateLabels];
}

- (IBAction)handleClickSetNeedsDisplay:(id)sender {
  CALayer * hostLayer = self.theView.layer;
  [hostLayer setNeedsDisplay];
  [self updateLabels];
}

- (IBAction)handleClickAnimatePosition:(id)sender {
  CGPoint const initialPosition = self.theView.center;
  NSTimeInterval const duration = 4.0f;
  
  [UIView animateWithDuration:(duration/2)
                   animations:^{
    self.theView.center = CGPointMake(initialPosition.x, initialPosition.y + 100);
  }
                   completion:^(BOOL finished) {
                     [UIView animateWithDuration:(duration/2)
                                      animations:^{
                                        self.theView.center = initialPosition;
                                      }
                                      completion:NULL];
                   }];
}

-(void)updateLabels
{
  self.labelViewOpaque.text = self.theView.opaque ? @"YES" : @"NO";
  [self.labelViewOpaque setNeedsDisplay];
  
  self.labelViewClipsToBounds.text = self.theView.clipsToBounds ? @"YES" : @"NO";
  [self.labelViewClipsToBounds setNeedsDisplay];
  
  self.labelViewAlpha.text = [NSString stringWithFormat:@"%.2f",self.theView.alpha];
  [self.labelViewAlpha setNeedsDisplay];
  
  self.labelLayerShadowOpacity.text = [NSString stringWithFormat:@"%.2f",self.theView.layer.shadowOpacity];
  
  self.labelLayerBackground.text = [NSString stringWithFormat:@"%p",self.theView.layer.backgroundColor];
  self.labelViewBackground.text =  [NSString stringWithFormat:@"%p",self.theView.backgroundColor.CGColor];
  self.labelLayerCornerRadius.text = [NSString stringWithFormat:@"%.1f",self.theView.layer.cornerRadius];
  self.labelLayerShouldRasterize.text = self.theView.layer.shouldRasterize ? @"YES" : @"NO";
}
@end
