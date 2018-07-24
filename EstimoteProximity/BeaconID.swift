//
//  BeaconID.swift
//  aupar
//
//  Created by Javier Cifuentes on 3/22/17.
//  Copyright © 2017 aritec-la. All rights reserved.
//

struct BeaconID: Equatable, CustomStringConvertible, Hashable {
    var description: String
    
    
    //let proximityUUID: UUID
    let major: Int //CLBeaconMajorValue
    let minor: Int //CLBeaconMinorValue
    var monitoring:Bool = false
    var ranging:Bool = false
    
    /*init(proximityUUID: UUID, major: Int, minor: Int) {
        self.proximityUUID = proximityUUID
        self.major = major
        self.minor = minor
    }*/
    init?(){
        //self.proximityUUID = UUID()
        self.major = 0
        self.minor = 0
        return nil;
    }
 
    
    //var asString: String {
       // get { return "\(proximityUUID.uuidString):\(major):\(minor)" }
    //}
    
    /*
    var asBeaconRegion: CLBeaconRegion {
        get { return CLBeaconRegion(
            proximityUUID: self.proximityUUID, major: self.major, minor: self.minor,
            identifier: self.asString) }
    }
    var asSimpleBeaconRegion: CLBeaconRegion{
        get { return CLBeaconRegion(
            proximityUUID: self.proximityUUID,
            identifier: self.asString) }
    
    }
    */
    /*var description: String {
        get { return self.asString }
    }
    
    var hashValue: Int {
        get { return self.asString.hashValue }
    }*/
    
    
    
    
}

/*
extension CLBeacon {
    
    var beaconID: BeaconID {
        get { return BeaconID(
            proximityUUID: proximityUUID,
            major: major.uint16Value,
            minor: minor.uint16Value) }
    }
    
}*/

