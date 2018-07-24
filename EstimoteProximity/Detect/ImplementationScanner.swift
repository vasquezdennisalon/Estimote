//
//  ImplementationScanner.swift
//  EstimoteProximity
//
//  Created by Denis Vásquez on 7/19/18.
//  Copyright © 2018 Denis Vásquez. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import EstimoteProximitySDK

class ImplementationScanner: EstimoteProximityScanner {
    
    init(estimoteProximityObserver:EPXProximityObserver, attachmentKey:String, attachmentValue:String, distance:Double){
        super.init(estimoteProximityObserver: estimoteProximityObserver, attachmentKey: attachmentKey, attachmentValue: attachmentValue, id: "", distance: distance)
    }
    
    override func getReleatedObjects()->Array<String>{
        let ids:Array<String> = []
        return ids
    }
    
    override func Validate(objectDetected: ObjectDetected) -> Bool {
        return true
    }
}
