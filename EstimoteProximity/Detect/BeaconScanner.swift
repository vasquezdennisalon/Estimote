//
//  BeaconScanner.swift
//  EstimoteProximity
//
//  Created by Denis Vásquez on 7/19/18.
//  Copyright © 2018 Denis Vásquez. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import EstimoteProximitySDK

class BeaconScanner: EstimoteProximityScanner {
    
    var sector:Sector?
    var releatedObjects: Array<String>?
    
    init(estimoteProximityObserver:EPXProximityObserver, attachmentKey:String, attachmentValue:String, sector:Sector){
        super.init(estimoteProximityObserver: estimoteProximityObserver, attachmentKey: attachmentKey, attachmentValue: attachmentValue, id: sector.getId(), distance: sector.getZone().getDistance())
        self.sector = sector
        self.getReleatedObjects()
    }
    
    override func getReleatedObjects()->Array<String>{
        self.releatedObjects = []
        if(self.releatedObjects?.count == 0){
            var ids:Array<String> = []
            self.sector?.getBeacons().forEach{beacon in
                ids.append(beacon.getId())
            }
            self.releatedObjects = ids
        }
        return self.releatedObjects!
    }
    
    override func OnObjectDetected(objectDetected: ObjectDetected) {
        print("LLEGA VALIDATE BEACONSCANNER \(objectDetected.Id)")
        if(self.Validate(objectDetected: objectDetected)){
            var object = ObjectDetected(id: (self.sector?.getId())!, type: objectDetected.type!)
            self.publishEvent(objectDetected: object)
        }
    }
    
}
