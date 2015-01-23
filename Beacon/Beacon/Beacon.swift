//
//  Beacon.swift
//  Beacon
//
//  Created by Daher Alfawares on 1/19/15.
//  Copyright (c) 2015 Daher Alfawares. All rights reserved.
//

import CoreBluetooth
import CoreLocation



class Beacon : NSObject, CBPeripheralManagerDelegate
{
    let beaconRegion        = CLBeaconRegion()
    let peripheralManager   = CBPeripheralManager()
    
    
    init( uuid: String, major: Int, minor: Int )
    {
        super.init()
        
        let UUID  = NSUUID(UUIDString: uuid)
        let Major = CLBeaconMajorValue( major )
        let Minor = CLBeaconMinorValue( minor )
        
        self.beaconRegion = CLBeaconRegion(proximityUUID: UUID, major: Major, minor: Minor, identifier: "com.solstice-mobile.beacon")
        self.peripheralManager.delegate = self;
    }
    
    func startAdvertising()
    {
        self.peripheralManager.startAdvertising( self.beaconRegion.peripheralDataWithMeasuredPower(nil) )
        
    }
    
    func stopAdvertising()
    {
        self.peripheralManager.stopAdvertising()
    }

    deinit
    {
        self.stopAdvertising()
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        
    }

}

