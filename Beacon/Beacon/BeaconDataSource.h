//
//  BeaconDataSource.h
//  Beacon
//
//  Created by Daher Alfawares on 12/9/14.
//  Copyright (c) 2014 Daher Alfawares. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeaconInfo.h"

@interface BeaconDataSource : NSObject

-(NSInteger)  count;
-(BeaconInfo*)beaconInfoAtIndex:(NSInteger)index;
@end
