//
//  Beacon.h
//  Beacon
//
//  Created by Daher Alfawares on 12/20/13.
//  Copyright (c) 2013 Daher Alfawares. All rights reserved.
//


#import "BeaconViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>


@interface Beacon : NSObject<CBPeripheralManagerDelegate>
@property CLBeaconRegion *beaconRegion;
@property CBPeripheralManager *peripheralManager;


-(id)initWithUUID:(std::string)UUID withMajor:(int)major withMinor:(int)minor;

-(void)startAdvertizing;
-(void)stopAdvertizing;

@end