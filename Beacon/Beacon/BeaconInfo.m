//
//  BeaconInfo.m
//  Beacon
//
//  Created by Daher Alfawares on 12/9/14.
//  Copyright (c) 2014 Daher Alfawares. All rights reserved.
//

#import "BeaconInfo.h"

@implementation BeaconInfo

-(instancetype)initWithName:(NSString*)name withImageName:(NSString*)imageName withUUIDString:(NSString*)UUIDString withMajor:(NSInteger)major withMinor:(NSInteger)minor
{
    self = [super init];
    if(self)
    {
        _name  = name;
        _image = imageName;
        _uuid  = UUIDString;
        _major = major;
        _minor = minor;
    }
    return self;
}

@end
