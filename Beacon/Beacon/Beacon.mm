//
//  Beacon.m
//  Beacon
//
//  Created by Daher Alfawares on 12/20/13.
//  Copyright (c) 2013 Daher Alfawares. All rights reserved.
//

#import "Beacon.h"
#import <map>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>

@interface Beacon()<CBPeripheralManagerDelegate>
@property CLBeaconRegion        * beaconRegion;
@property CBPeripheralManager   * peripheralManager;
@end


@implementation Beacon

-(id)initWithUUID:(NSString*)UUID withMajor:(int)major withMinor:(int)minor
{
    self = [super init];
    if(self)
    {
        // Beacon UUID
        NSUUID *proximityUUID = [[NSUUID alloc] initWithUUIDString:UUID];

        // Create the beacon region.
        self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:proximityUUID
                                                                    major:major
                                                                    minor:minor
                                                               identifier:@"com.solstice-mobile.meetup"];

        // Create the peripheral manager.
        self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:nil];
    }
    return self;
}

-(void)startAdvertizing
{
    // Create a dictionary of advertisement data.
    NSDictionary *beaconPeripheralData = [self.beaconRegion peripheralDataWithMeasuredPower:nil];
    
    // Start advertising your beacon's data.
    [self.peripheralManager startAdvertising:beaconPeripheralData];
}

-(void)stopAdvertizing
{
    if( [self.peripheralManager isAdvertising] )
        [self.peripheralManager stopAdvertising];
}

#pragma mark Peripheral Manager Delegate

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    std::map<CBPeripheralManagerState, const char*> states;
    
    states[CBPeripheralManagerStateUnknown]         = "The current state of the peripheral manager is unknown; an update is imminent.";
    states[CBPeripheralManagerStateResetting]       = "The connection with the system service was momentarily lost; an update is imminent.";
    states[CBPeripheralManagerStateUnsupported]     = "The platform doesn't support the Bluetooth low energy peripheral/server role.";
    states[CBPeripheralManagerStateUnauthorized]    = "The app is not authorized to use the Bluetooth low energy peripheral/server role.";
    states[CBPeripheralManagerStatePoweredOff]      = "Bluetooth is currently powered off.";
    states[CBPeripheralManagerStatePoweredOn]       = "Bluetooth is currently powered on and is available to use.";
    
    NSLog(@"Peripheral state: %s", states[[peripheral state]] );
}

-(void)dealloc
{
    [self stopAdvertizing];
}

@end

