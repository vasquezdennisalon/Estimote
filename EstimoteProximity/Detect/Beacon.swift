//
//  Beacon.swift
//  EstimoteProximity
//
//  Created by Denis Vásquez on 7/19/18.
//  Copyright © 2018 Denis Vásquez. All rights reserved.
//

import UIKit

class Beacon: NSObject {
    
    private(set) var Id:String?
    
    func setId(id:String){
        self.Id = id
    }
    
    func getId()->String{
        return self.Id!
    }
    
}
