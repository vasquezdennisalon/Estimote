//
//  simulatorWS.swift
//  EstimoteProximity
//
//  Created by Denis Vásquez on 7/17/18.
//  Copyright © 2018 Denis Vásquez. All rights reserved.
//

import UIKit

class simulatorWS: NSObject {
    static let shared = simulatorWS()
    var implementations: Array<BeaconStruct.BeaconsJson> = []
    
    func getImplementation(nameFile: String){
        let filePath = Bundle.main.path(forResource: nameFile, ofType: "json", inDirectory: nil)
        if let filePath = filePath {
            do {
                let fileUrl = URL(fileURLWithPath: filePath)
                let jsonData = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                let jsonDecoder = JSONDecoder()
                implementations =  [try JSONDecoder().decode(BeaconStruct.BeaconsJson.self, from: jsonData)]
            } catch {
                print(error)
                fatalError("Unable to read contents of the file url")
            }
        }
    }
    
    func FindByBeaconId(BeaconFind:String)->Array<BeaconStruct.BeaconsJson>{
        var data: Array<BeaconStruct.BeaconsJson> = []
        
        implementations.forEach{ implementation in
            let zonas = implementation.proximityZones
            zonas.forEach{ zona in
                let sectores = zona.sectors
                sectores.forEach{ sector in
                    let beacons = sector.beacons
                    beacons.forEach{ beacon in
                        if(beacon.uuid == BeaconFind){
                            data = [implementation]
                            return
                        }
                    }
                }
            }
        }
        
        return data
    }
    
    
}
