//
//  BeaconDataSource.swift
//  Beacon
//
//  Created by Daher Alfawares on 1/19/15.
//  Copyright (c) 2015 Daher Alfawares. All rights reserved.
//

class BeaconDataSource
{
    func count() -> Int
    {
        return 4
    }
    
    func beaconInfoAtIndex( index : Int ) -> BeaconInfo
    {
        switch( index )
        {
        case 0: return BeaconInfo( name: "Gap",                    image: "discover_ibeacon_signal_gap",       uuid : "360F40D6-1375-4877-93FB-E48249C95B29", major: 0,  minor: 0)
        case 1: return BeaconInfo( name: "McDonald's",             image: "discover_ibeacon_signal_mcd",       uuid : "360F40D6-1375-4877-93FB-E48249C95B29", major: 1,  minor: 0)
        case 2: return BeaconInfo( name: "Lowes",                  image: "discover_ibeacon_signal_lowes",     uuid : "360F40D6-1375-4877-93FB-E48249C95B29", major: 2,  minor: 0)
        case 3: return BeaconInfo( name: "Smart Office (Sales)",   image: "discover_ibeacon_signal_solstice",  uuid : "360F40D6-1375-4877-93FB-E48249C95B29", major: 99, minor: 31072)
        default: break
        }
        
        return self.beaconInfoAtIndex(0)
    }
}

