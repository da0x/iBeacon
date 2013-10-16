//
//  AppDelegate.m
//  BeaconMap
//
//  Created by Pablo Bartolome on 10/10/13.
//  Copyright (c) 2013 Solstice Mobile. All rights reserved.
//

#import "AppDelegate.h"

#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>

static NSString *const UUID = @"74278BDA-B644-4520-8F0C-720EAF059935";
static NSString *const identifier = @"meetup.poc";

@interface AppDelegate () <CLLocationManagerDelegate>

@property CLBeaconRegion *beaconRegion;
@property CLLocationManager *manager;
@property BOOL enrolledInWaitList;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //Construct the region
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:UUID] identifier:identifier];
    self.beaconRegion.notifyEntryStateOnDisplay = YES ;
    self.beaconRegion.notifyOnExit = YES;
    
    //Start monitoring
    self.manager = [[CLLocationManager alloc] init];
    [self.manager setDelegate:self];
    [self.manager startMonitoringForRegion:self.beaconRegion];
    
    [self.manager requestStateForRegion:self.beaconRegion];
    NSLog(@"Started Monitoring for Beacon Region");
    
    return YES;
}

#pragma mark - CLLocationManagerDelegate Methods

//Callback when the iBeacon is in range
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        [manager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
        NSLog(@"Started Monitoring stuff !!");
    }
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
    
}

/*
 * Delegate Method that gets called all the time
 */
-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    
    [manager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
    
    NSLog(@"State of the region: state %i region %@",(int)state,region);
    
    UILocalNotification *notification = [UILocalNotification new];

    if(state == CLRegionStateInside) {
        notification.alertBody = @"Welcome! Do you want to open the app?";
        notification.soundName = UILocalNotificationDefaultSoundName;
    }
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Failed With Error");
}

//Callback when the iBeacon has left range
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        [manager stopRangingBeaconsInRegion:(CLBeaconRegion *)region];
    }
}

-(void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager
{
    NSLog(@"Did pasued location updates");
}

-(void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager
{
    NSLog(@"Did resume location updates");
}

//Callback when ranging is successful
- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region
{
    for (CLBeacon *beacon in beacons) {
        [self.mapViewController beaconReceived:beacon];
    }
    
}

@end
