//
//  BeaconViewController.h
//  Beacon
//
//  Created by Daher Alfawares on 9/27/13.
//  Copyright (c) 2013 Daher Alfawares. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BeaconInfo;

@interface BeaconViewController : UIViewController

@property (nonatomic) NSString* beaconUUID;
@property (nonatomic) NSString* beaconTitle;
@property (nonatomic) NSString* beaconImageName;
@property (nonatomic) NSInteger beaconMajor;
@property (nonatomic) NSInteger beaconMinor;
@end
