//
//  BeaconStruct.swift
//  EstimoteProximity
//
//  Created by Denis Vásquez on 7/17/18.
//  Copyright © 2018 Denis Vásquez. All rights reserved.
//

import UIKit

class BeaconStruct: NSObject {
    struct BeaconsJson : Codable {
        struct proximityZonesStruct: Codable {
            let id: String!
            let name: String!
            let distance: Float
            let sectors: [sectorsStruct]
        }
        
        struct sectorsStruct: Codable {
            let id: String!
            let name: String!
            let beacons: [beaconsStruct]
        }
        
        struct beaconsStruct: Codable {
            let id: String
            let uuid: String
            let major: Int
            let minor: Int
        }
        
        let id: String!
        let colorHex: String!
        let logoUrl: String!
        let proximityZones: [proximityZonesStruct]
    }
}
