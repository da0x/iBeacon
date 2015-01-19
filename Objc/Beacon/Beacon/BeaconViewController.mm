//
//  BeaconViewController.m
//  Beacon
//
//  Created by Daher Alfawares on 9/27/13.
//  Copyright (c) 2013 Daher Alfawares. All rights reserved.
//

#import "BeaconViewController.h"
#import "BeaconDataSource.h"
#import "Beacon.h"


@interface BeaconViewController ()

@property          Beacon      * beacon;
@property IBOutlet UISwitch    * beaconSwitch;
@property IBOutlet UIImageView * beaconLogo;
@end

@implementation BeaconViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
        // Model
    self.beacon             = [[Beacon alloc] initWithUUID:self.beaconUUID withMajor:self.beaconMajor withMinor:self.beaconMinor];
    
        // View
    self.title              = self.beaconTitle;
    self.beaconLogo.image   = [UIImage imageNamed:self.beaconImageName];
    
        // control
    [self.beaconSwitch addTarget:self action:@selector(switchChanged) forControlEvents:UIControlEventValueChanged];
}

-(void)switchChanged
{
    if( [self.beaconSwitch isOn] )
    {
        [self.beacon startAdvertizing];
    }
    else
    {
        [self.beacon stopAdvertizing];
    }
}

-(IBAction)toggle:(id)sender
{
    [self.beaconSwitch setOn:![self.beaconSwitch isOn] animated:true];
    [self switchChanged];
}

-(void)dealloc
{
        // Responsibility error.
    [self.beacon stopAdvertizing];
}

@end


