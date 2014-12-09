//
//  BeaconInfo.h
//  Beacon
//
//  Created by Daher Alfawares on 12/9/14.
//  Copyright (c) 2014 Daher Alfawares. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeaconInfo : NSObject

@property (nonatomic,readonly) NSString* name;
@property (nonatomic,readonly) NSString* image;
@property (nonatomic,readonly) NSString* uuid;
@property (nonatomic,readonly) NSInteger major;
@property (nonatomic,readonly) NSInteger minor;

-(instancetype)initWithName:(NSString*)name withImageName:(NSString*)imageName withUUIDString:(NSString*)UUIDString withMajor:(NSInteger)major withMinor:(NSInteger)minor;
@end
