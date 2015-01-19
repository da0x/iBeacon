//
//  ViewController.h
//  BeaconMap
//
//  Created by Pablo Bartolome on 10/10/13.
//  Copyright (c) 2013 Solstice Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController

- (void)beaconReceived:(CLBeacon*)beacon;

@end
