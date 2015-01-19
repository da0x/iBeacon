//
//  BeaconCentral.h
//  preseNT
//
//  Created by Daher Alfawares on 1/15/15.
//  Copyright (c) 2015 Northern Trust. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol BeaconCentralDelegate <NSObject>
-(void)beaconFound;
@end


@interface BeaconCentral : NSObject
@property (nonatomic, weak) id<BeaconCentralDelegate> delegate;

-(id)initWithUUID:(NSString *)proximityUUID;

-(void)startListening;
-(void)stopListening;
@end
