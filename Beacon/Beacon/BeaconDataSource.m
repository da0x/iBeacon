//
//  BeaconDataSource.m
//  Beacon
//
//  Created by Daher Alfawares on 12/9/14.
//  Copyright (c) 2014 Daher Alfawares. All rights reserved.
//

#import "BeaconDataSource.h"


@implementation BeaconDataSource

-(NSInteger)count
{
    return 4;
}

-(BeaconInfo*)beaconInfoAtIndex:(NSInteger)index
{
    switch (index) {
        case 0: return [[BeaconInfo alloc] initWithName:@"Gap"                  withImageName:@"discover_ibeacon_signal_gap"      withUUIDString:@"360F40D6-1375-4877-93FB-E48249C95B29" withMajor:0  withMinor:0];
        case 1: return [[BeaconInfo alloc] initWithName:@"McDonald's"           withImageName:@"discover_ibeacon_signal_mcd"      withUUIDString:@"360F40D6-1375-4877-93FB-E48249C95B29" withMajor:1  withMinor:0];
        case 2: return [[BeaconInfo alloc] initWithName:@"Lowes"                withImageName:@"discover_ibeacon_signal_lowes"    withUUIDString:@"360F40D6-1375-4877-93FB-E48249C95B29" withMajor:2  withMinor:0];
        case 3: return [[BeaconInfo alloc] initWithName:@"Smart Office (Sales)" withImageName:@"discover_ibeacon_signal_solstice" withUUIDString:@"360F40D6-1375-4877-93FB-E48249C95B29" withMajor:99 withMinor:31072];
    }
    return nil;
}

@end
