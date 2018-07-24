//
//  ObjectDetected.swift
//  EstimoteProximity
//
//  Created by Denis Vásquez on 7/18/18.
//  Copyright © 2018 Denis Vásquez. All rights reserved.
//

import UIKit

enum EventType
{
    case OnEnter
    case OnChange
    case OnExit
}

class ObjectDetected: NSObject {
    //static let shared = ObjectDetected()
    
    var Id:String? = nil
    var type:EventType? = nil

    /*func constructor(id:UUID, type:EventType){
        self.Id = id
        self.type = type
    }*/
    
    init(id:String, type:EventType){
        self.Id = id
        self.type = type
    }
    
}
