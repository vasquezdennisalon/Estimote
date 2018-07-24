//
//  SectorScanner.swift
//  EstimoteProximity
//
//  Created by Denis Vásquez on 7/18/18.
//  Copyright © 2018 Denis Vásquez. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import EstimoteProximitySDK

class SectorScanner: ProximityScanner<ObjectDetected> {
    
    private(set) var releatedObjects: Array<String>?
    var customObservable:PublishSubject<ObjectDetected>?
    private(set) var implementation:Implementation?
    private(set) var estimoteProximityObserver:EPXProximityObserver?
    var beaconsInSectorDetectedObservable:Observable<ObjectDetected>?
    var sectorObserver:Disposable?
    
    init(estimoteProximityObserver: EPXProximityObserver, implementation:Implementation) {
        super.init(Id: implementation.getId(), distance: 0)
        self.implementation = implementation;
        print("llega implementación 2 \(implementation.getSector().first?.getId())")
        self.estimoteProximityObserver = estimoteProximityObserver;
        self.getReleatedObjects()
    }
    
    override func getReleatedObjects()->Array<String>{
        self.releatedObjects = []
        if(self.releatedObjects?.count == 0){
            var ids:Array<String> = []
            self.implementation?.getSector().forEach{ sector in
                ids.append(sector.getId())
            }
            print("Esta cargando la implementación \(ids)")
            self.releatedObjects = ids
        }
        print("Resultado final \(self.releatedObjects)")
        return self.releatedObjects!
    }
    
    override func getSource()->Observable<ObjectDetected>{
        if(self.customObservable == nil){
            self.customObservable = PublishSubject<ObjectDetected>()
        }
        
        return customObservable!
    }
    
    override func dispose(){
        if(self.customObservable != nil){
            self.customObservable?.dispose()
        }
        
        if(self.sectorObserver != nil){
            self.sectorObserver?.dispose()
        }
    }
    
    override func subscribe<O>(_ observer: O) -> Disposable where ObjectDetected == O.E, O : ObserverType {
        var scanners:Array<BeaconScanner> = []
        print("llego hasta suscribe de sectro scanner")
        if(beaconsInSectorDetectedObservable == nil){
            print("llego hasta suscribe de sectro scanner 2")
            self.implementation?.getSector().forEach{ sector in
                if(beaconsInSectorDetectedObservable == nil){
                    beaconsInSectorDetectedObservable = BeaconScanner(estimoteProximityObserver: self.estimoteProximityObserver!, attachmentKey: "AuparCustomZone", attachmentValue: "AuparCustomZone", sector: sector).asObservable()
                }else{
                    
                    let beacon = BeaconScanner(estimoteProximityObserver: self.estimoteProximityObserver!, attachmentKey: "AuparCustomZone", attachmentValue: "AuparCustomZone", sector: sector).asObservable()
                    beaconsInSectorDetectedObservable = Observable.merge(beacon, beaconsInSectorDetectedObservable!)
                }
                
                self.sectorObserver = beaconsInSectorDetectedObservable?.subscribe(onNext: {
                    sectorDetected in
                    print("LLEGA sector onNext \(sectorDetected)")
                    self.OnObjectDetected(objectDetected: sectorDetected)
                })
            }
        }
        
        return self.getSource().subscribe(observer)
    }
    
    override func publishEvent(objectDetected:ObjectDetected){
        //self.customObservable?.onNext(ObjectDetected)
        self.customObservable?.onNext(objectDetected)
    }
}
