//
//  ImplementationProvider.swift
//  EstimoteProximity
//
//  Created by Denis Vásquez on 7/20/18.
//  Copyright © 2018 Denis Vásquez. All rights reserved.
//

import UIKit

class ImplementationProvider: NSObject {
    
    static let shared = ImplementationProvider()
    var implementatationData:ImplementationStruct.ImplementationJson?
    var implementation:Implementation?
    
    func getBeaconsJson(){
        let filePath = Bundle.main.path(forResource: "data4", ofType: "json", inDirectory: nil)
        if let filePath = filePath {
            do {
                let fileUrl = URL(fileURLWithPath: filePath)
                let jsonData = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                let root =  try JSONDecoder().decode(ImplementationStruct.ImplementationJson.self, from: jsonData)
                var zones:Array<Zone> = []
                var zone:Zone?
                root.zonas.forEach{zona in
                    zone = Zone(distance: zona.distance)
                    zone?.setId(Id: zona.id)
                    zone?.setName(name: zona.name)
                    zones.append(zone!)
                    print("ENTRA ACA")
                }
                var sectors:Array<Sector> = []
                var sectorData:Sector?
                var beacons:Array<Beacon> = []
                var beaconData:Beacon?
                root.sectors.forEach{ sector in
                    beacons = []
                    sector.beacons.forEach{ beacon in
                        beaconData = Beacon()
                        beaconData?.setId(id: beacon.id)
                        beacons.append(beaconData!)
                    }
                    var zone = self.getZone(zones: zones, id: sector.zonaId)
                    var id = sector.id
                    sectorData = Sector(id: id, zone: zone, beacons: beacons)
                    sectors.append(sectorData!)
                }
                print(sectors)
                implementation = Implementation(Id: root.id, sector: sectors)
            } catch {
                print(error)
                fatalError("Unable to read contents of the file url")
            }
        }
    }
    
    func FindByBeaconId(Id:String)->Implementation?{
        var data:Implementation?
        
        let sectors = implementation?.getSector()
        var exists:Bool = false
        sectors?.forEach{sector in
            let beacons = sector.getBeacons()
            beacons.forEach{beacon in
                if(beacon.getId() == Id){
                    exists = true
                    data = implementation
                    return
                }
                if(exists){
                    return
                }
            }
        }
        
        if exists {
            return data!
        }else{
            
        }
        
        return data
    }
    
    func getZone(zones:Array<Zone>, id:String)->Zone{
        var zone:Zone? = nil
        zones.forEach{zona in
            if(zona.id == id){
                zone = zona
            }
        }
        return zone!
    }
}
