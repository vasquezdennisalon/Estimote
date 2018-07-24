//
//  Zone.swift
//  EstimoteProximity
//
//  Created by Denis Vásquez on 7/19/18.
//  Copyright © 2018 Denis Vásquez. All rights reserved.
//

import UIKit

class Zone: NSObject {
    private(set) var distance:Double = 0
    var id:String?
    var name:String?
    
    init(distance:Double) {
        self.distance = distance
    }
    
    func getDistance()->Double{
        return self.distance
    }
    
    func setId(Id:String){
        self.id = Id
    }
    
    func setName(name:String){
        self.name = name
    }
    
}
