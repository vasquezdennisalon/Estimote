//
//  ImplementationStruct.swift
//  EstimoteProximity
//
//  Created by Denis Vásquez on 7/20/18.
//  Copyright © 2018 Denis Vásquez. All rights reserved.
//

import UIKit

class ImplementationStruct: NSObject {
    struct ImplementationJson : Codable {
        struct beaconsStruct: Codable {
            let id: String
            let uuid: String
            let major: Int
            let minor: Int
        }
        
        struct zoneStruct: Codable {
            let id:String
            let name:String
            let distance:Double
        }
        
        struct sectorStruct: Codable {
            let id:String
            let name:String
            let zonaId:String
            let beacons:[beaconsStruct]
        }
        
        let id: String!
        let colorHex: String!
        let logoUrl: String!
        let zonas:[zoneStruct]
        let sectors:[sectorStruct]
    }
}
