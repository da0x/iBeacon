//
//  WelcomeViewController.m
//  SmartHub
//
//  Created by Daher Alfawares on 10/4/13.
//  Copyright (c) 2013 Daher Alfawares. All rights reserved.
//

#import "WelcomeViewController.h"

@interface WelcomeViewController ()

@end

@implementation WelcomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CATransform3D transform = CATransform3DMakeRotation(3*M_PI_2, 0, 0, 1);
    
    [self.view.layer setTransform:transform];
    for(UIView *view in self.view.subviews){
        view.layer.transform = transform;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
