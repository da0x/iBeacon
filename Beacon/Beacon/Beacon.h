//
//  Beacon.h
//  Beacon
//
//  Created by Daher Alfawares on 12/20/13.
//  Copyright (c) 2013 Daher Alfawares. All rights reserved.
//


#include <string>


@interface Beacon : NSObject

-(id)initWithUUID:(NSString*)UUID withMajor:(int)major withMinor:(int)minor;

-(void)startAdvertizing;
-(void)stopAdvertizing;

@end