//
//  Sector.swift
//  EstimoteProximity
//
//  Created by Denis Vásquez on 7/19/18.
//  Copyright © 2018 Denis Vásquez. All rights reserved.
//

import UIKit

class Sector: NSObject {
    private(set) var Id:String?
    private(set) var zone:Zone?
    private(set) var beacons:Array<Beacon>?
    
    init(id:String, zone:Zone, beacons:Array<Beacon>){
        self.Id = id
        self.zone = zone
        self.beacons = beacons
    }
    
    func getId()->String{
        return self.Id!
    }
    
    func getZone()->Zone{
        return self.zone!
    }
    
    func getBeacons()->Array<Beacon>{
        return self.beacons!
    }
    
}
