//
//  BeaconViewController.h
//  Beacon
//
//  Created by Daher Alfawares on 9/27/13.
//  Copyright (c) 2013 Daher Alfawares. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <string>

@interface BeaconViewController : UIViewController
@property std::string beaconUUID;
@property std::string beaconTitle;
@property std::string beaconImageName;
@property int beaconMajor;
@property int beaconMinor;
@end
