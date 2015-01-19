//
//  BeaconInfo.swift
//  Beacon
//
//  Created by Daher Alfawares on 1/19/15.
//  Copyright (c) 2015 Daher Alfawares. All rights reserved.
//


/// Responsible for holding beacon data objects.

class BeaconInfo {
    
    var name : String
    var image : String
    var uuid : String
    var major : Int
    var minor : Int
    

    init( name : String, image : String, uuid : String, major: Int, minor: Int)
    {
        self.name = name
        self.image = image
        self.uuid = uuid
        self.major = major
        self.minor = minor
    }
}
