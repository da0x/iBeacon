//
//  ExplorerViewController.m
//  Explorer
//
//  Created by Daher Alfawares on 9/27/13.
//  Copyright (c) 2013 Daher Alfawares. All rights reserved.
//

#import "ExplorerViewController.h"
#import <CoreLocation/CoreLocation.h>
#include <map>
#include "DA_ASCII_Table.h"

@interface Explorer : NSObject<CLLocationManagerDelegate>
@property int proximity;
@property CLBeaconRegion *beaconRegion;
@property CLLocationManager* locationManager;
@property UILabel* distanceLabel1;// temporary
@property UILabel* distanceLabel2;// temporary
@end

@implementation Explorer

-(id)initWithUUID:(NSString *)proximityUUID
{
    self = [super init];
    if(self)
    {
        NSLog(@"Monitoring availability       : %@",[CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]] ? @"Yes" : @"No");
        NSLog(@"Location authorization status : %d",[CLLocationManager authorizationStatus]);
        NSLog(@"Location ranging supported    : %@",[CLLocationManager isRangingAvailable] ? @"Yes":@"No");
        
      
            // Create the beacon region to be monitored.
            self.beaconRegion = [[CLBeaconRegion alloc]
                                            initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:proximityUUID]
                                            identifier:@"com.solstice-mobile.meetup"];
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        
        
        // Register the beacon region with the location manager.
        [self.locationManager startMonitoringForRegion:self.beaconRegion];
        
        self.proximity = CLProximityUnknown;
            
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    if( [region isKindOfClass:[CLBeaconRegion class]] )
    {
        [manager startRangingBeaconsInRegion:(CLBeaconRegion*)region];
    }
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    if( [region isKindOfClass:[CLBeaconRegion class]] )
    {
        [manager stopRangingBeaconsInRegion:(CLBeaconRegion*)region];
    }
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region {
    
    std::map<CLProximity,const char*> proximityText;
    
    proximityText[CLProximityUnknown]   = "The proximity of the beacon could not be determined.";
    proximityText[CLProximityImmediate] = "The beacon is in the user’s immediate vicinity.";
    proximityText[CLProximityNear]      = "The beacon is relatively close to the user.";
    proximityText[CLProximityFar]       = "The beacon is far away.";
    
    
    
    ascii::table myTable("Proximity Update");
    myTable ("Proximity")("Accuracy")("RSSI")++;
    
    for( int i=0; i< [beacons count]; i++ )
    {
        CLBeacon *beacon = [beacons objectAtIndex:i];
        
        NSLog(@"Beacon : %@",beacon);
        
        std::string proximity = proximityText[[beacon proximity]];
        
        std::stringstream accuracy;
        accuracy << [beacon accuracy];
        std::stringstream rssi;
        rssi << [beacon rssi];
        
        myTable (proximity)(accuracy.str())(rssi.str())++;
        
        NSString* distance;
        NSString* unit;
        
        if( [beacon accuracy] > 1 )
        {
            distance = [NSString stringWithFormat:@"%.2f",[beacon accuracy]];
            unit = @"m";
        }
        else
        {
            distance = [NSString stringWithFormat:@"%.2f",[beacon accuracy]*100];
            unit = @"cm";
        }
        
        if ( beacon.major > 0 )
            self.distanceLabel1.text = [NSString stringWithFormat:@"Beacon 1: %d +/- %@ %@", [beacon proximity], distance, unit];
        else
            self.distanceLabel2.text = [NSString stringWithFormat:@"Beacon 2: %d +/- %@ %@", [beacon proximity], distance, unit];
        
        self.proximity = beacon.proximity;
    }
    std::cout << myTable << std::endl;
}

@end



@interface ExplorerViewController ()
@property Explorer *explorer;
@property IBOutlet UILabel *distance1;
@property IBOutlet UILabel *distance2;
@property NSTimer *timer;
@end

@implementation ExplorerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.explorer = [[Explorer alloc] initWithUUID:@"91295548-F1E9-41F3-851D-075DCDF192B9"];
    self.explorer.distanceLabel1 = self.distance1;
    self.explorer.distanceLabel2 = self.distance2;
    
//    NSString *ipAddress = address.text;
//    
//    if(ipAddress == nil ||
//       [ipAddress isEqualToString:@""])
//    {
//        ipAddress = @"192.168.10.114";
//    }
//    
//    client = [[FastSocket alloc] initWithHost:ipAddress andPort:@"35000"];
//    
//    [client connect];
    
//    if([client isConnected])
//    {
//        char *bytes = "test";
//        [client sendBytes:bytes count:strlen(bytes)+1];
//    }
    
    
    self.timer = [NSTimer timerWithTimeInterval:.5 target:self selector:@selector(tick) userInfo:nil repeats:true];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

-(void)tick
{
    if( self.explorer.proximity == CLProximityUnknown )
        return;
    
    if( self.explorer.proximity == CLProximityImmediate || self.explorer.proximity == CLProximityNear )
    {
        [self userNear:nil];
    }
    else
    {
        [self userAway:nil];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [client close];
    client = nil;
}

- (IBAction)userNear:(id)sender
{
    if( !address.text.length )
        return;
    
    if(client == nil ||
       ![client isConnected])
    {
        client = [[FastSocket alloc] initWithHost:address.text andPort:@"35000"];
        
        [client connect];
    }
    
    if([client isConnected])
    {
        char *bytes = "distance:0";
        [client sendBytes:bytes count:strlen(bytes)+1];
    }
}

- (IBAction)userAway:(id)sender
{
    if( !address.text.length )
        return;
    
    if(client == nil ||
       ![client isConnected])
    {
        client = [[FastSocket alloc] initWithHost:address.text andPort:@"35000"];
        
        [client connect];
    }
    
    if([client isConnected])
    {
        char *bytes = "distance:1";
        [client sendBytes:bytes count:strlen(bytes)+1];
    }
}

@end
