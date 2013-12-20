//
//  BeaconViewController.m
//  Beacon
//
//  Created by Daher Alfawares on 9/27/13.
//  Copyright (c) 2013 Daher Alfawares. All rights reserved.
//

#import "BeaconViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>
#include <map>


@interface Beacon : NSObject<CBPeripheralManagerDelegate>
@property CLBeaconRegion *beaconRegion;
@property CBPeripheralManager *peripheralManager;
@end

@implementation Beacon

-(id)initWithUUID:(std::string)UUID withMajor:(int)major withMinor:(int)minor
{
    self = [super init];
    if(self)
    {
        // Beacon UUID
        NSUUID *proximityUUID = [[NSUUID alloc]
                                 initWithUUIDString:[NSString stringWithUTF8String:UUID.c_str()]];
        
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
    
    NSLog(@"Peripheral state: %s",states[[peripheral state]]);
}

-(void)dealloc
{
    [self stopAdvertizing];
}

@end

@interface BeaconViewController ()
@property Beacon* beacon;
@property IBOutlet UISwitch* beaconSwitch;
@property IBOutlet UIImageView* beaconLogo;
@end

@implementation BeaconViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.beacon = [[Beacon alloc] initWithUUID:self.beaconUUID
                                     withMajor:self.beaconMajor
                                     withMinor:self.beaconMinor];
    
    self.title = [NSString stringWithUTF8String:self.beaconTitle.c_str()];
    self.beaconLogo.image = [UIImage imageNamed:[NSString stringWithUTF8String:self.beaconImageName.c_str()]];
    
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

@end
