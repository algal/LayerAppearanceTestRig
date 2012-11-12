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

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  
  CGRect imgFrame = CGRectMake(100, 100, 100, 100);
  UIView *imgView = [[UIView alloc] initWithFrame:imgFrame];
  imgView.backgroundColor = [UIColor clearColor];
  UIImage *image = [UIImage imageNamed:@"mandel_images.png"];
  imgView.layer.backgroundColor = [UIColor colorWithPatternImage:image].CGColor;
  
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
  
  [self.view addSubview:imgView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
