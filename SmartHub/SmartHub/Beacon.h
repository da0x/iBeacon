//
//  Beacon.h
//  SmartHub
//
//  Created by Robbie Plankenhorn on 10/4/13.
//  Copyright (c) 2013 Daher Alfawares. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>

@interface Beacon : NSObject<CBPeripheralManagerDelegate>

@property CLBeaconRegion *beaconRegion;
@property CBPeripheralManager *peripheralManager;

@end
