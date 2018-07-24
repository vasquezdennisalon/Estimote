//
//  Implementation.swift
//  EstimoteProximity
//
//  Created by Denis Vásquez on 7/19/18.
//  Copyright © 2018 Denis Vásquez. All rights reserved.
//

import UIKit

class Implementation: NSObject {
    
    private(set) var Id:String?
    private(set) var sector:Array<Sector>?
    
    init(Id:String, sector:Array<Sector>){
        self.Id = Id
        self.sector = sector
    }
    
    func getId()->String{
        return self.Id!
    }
    
    func getSector()->Array<Sector>{
        return self.sector!
    }
    
}
