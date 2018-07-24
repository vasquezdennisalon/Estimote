    //
//  ProximityScanner.swift
//  EstimoteProximity
//
//  Created by Denis Vásquez on 7/18/18.
//  Copyright © 2018 Denis Vásquez. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


    
class ProximityScanner<T>: ObservableType, Disposable where T:ObjectDetected {
    typealias E = T
    
    var Id:String? = nil
    var source: Observable<T>  = PublishSubject<T>()
    var ReleatedObjects: Array<String>?
    var Distance:Double
    
    init(Id: String, distance:Double) {
        self.Id = Id
        self.Distance = distance
    }
    
    func getId()->String{
        return self.Id!
    }
    
    func getReleatedObjects()->Array<String>{
        return self.ReleatedObjects!
    }
    
    func getDistance()->Double{
        return self.Distance
    }
    
    func getSource()->Observable<T>{
        return source
    }
    
    func subscribe<O: ObserverType>(_ observer: O) -> Disposable where O.E == E {
        observer.onCompleted()
        
        return (source.subscribe(observer))
    }
    
    func Validate(objectDetected:T)->Bool {
        print("VAlidate ProximityScanner \(self.ReleatedObjects)")
        if(self.ReleatedObjects != nil){
            if (self.ReleatedObjects?.contains(objectDetected.Id!))!{
                return true
            }
        }
        return false
    }
    
    func OnObjectDetected(objectDetected:T){
        if(self.Validate(objectDetected: objectDetected)){
                self.publishEvent(objectDetected: objectDetected)
        }
    }
    
    func publishEvent(objectDetected:T){}
    
    func dispose(){}
}
