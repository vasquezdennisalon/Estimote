//
//  EstimoteProximityScanner.swift
//  EstimoteProximity
//
//  Created by Denis Vásquez on 7/19/18.
//  Copyright © 2018 Denis Vásquez. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import EstimoteProximitySDK

class EstimoteProximityScanner: ProximityScanner<ObjectDetected> {
    var attachmentKey:String?
    var attachmentValue:String?
    var estimoteProximityObserver:EPXProximityObserver?
    
    var ProximityObserver:EPXProximityObserver?
    var proximityZone:EPXProximityZone?
    var proximityHandler:EPXProximityObserver?
    var customObservable: PublishSubject<ObjectDetected>?
    
    var auparObserver: EPXProximityObserver!
    
    init(estimoteProximityObserver: EPXProximityObserver, attachmentKey:String, attachmentValue:String, id:String, distance:Double){
        super.init(Id: id, distance: distance)
        self.estimoteProximityObserver = estimoteProximityObserver
        self.attachmentKey = attachmentKey
        self.attachmentValue = attachmentValue
    }
    
    override func subscribe<O>(_ observer: O) -> Disposable where ObjectDetected == O.E, O : ObserverType {
        if(self.proximityZone == nil){
            self.proximityZone = EPXProximityZone(range: EPXProximityRange.custom(desiredMeanTriggerDistance: self.getDistance())!, attachmentKey: self.attachmentKey!, attachmentValue: self.attachmentValue!)
            
            self.proximityZone?.onEnterAction = {attachment in
                //print("Enter Aupar (custom range)")
                //print("Change Aupar (custom range)")
                //print("\(attachment)")
                
                //print("Identifier is: \(attachment.deviceIdentifier)")
                
                //let data = attachment.payload["uuid:major:minor"] as! String
                //let attachmentParts = data.components(separatedBy: ":")
                //print("\(attachmentParts[0])")
                let object = ObjectDetected(id: attachment.deviceIdentifier, type: EventType.OnEnter)
                self.OnObjectDetected(objectDetected: object)
            }
            self.proximityZone?.onChangeAction = {attachment in
                /*print("Change Aupar (custom range)")
                print("\(attachment.first?.deviceIdentifier)")*/
                if(attachment.count > 0){
                    let object = ObjectDetected(id: (attachment.first?.deviceIdentifier)!, type: EventType.OnChange)
                    self.OnObjectDetected(objectDetected: object)
                }
            }
            self.proximityZone?.onExitAction = {attachment in
                /*print("Exit Aupar (custom range)")
                print("\(attachment)")*/
                let object = ObjectDetected(id: attachment.deviceIdentifier, type: EventType.OnExit)
                self.OnObjectDetected(objectDetected: object)
            }
            self.estimoteProximityObserver?.startObserving([self.proximityZone!])
        }
        
        return self.getSource().subscribe(observer)
    }
    
    override func getSource() -> Observable<ObjectDetected> {
        if(self.customObservable == nil){
            self.customObservable = PublishSubject<ObjectDetected>()
        }
        return self.customObservable!
    }
    
    override func publishEvent(objectDetected: ObjectDetected) {
        self.customObservable?.onNext(objectDetected)
    }
    
    override func dispose() {
        if(self.proximityZone != nil){
            self.estimoteProximityObserver?.stopObservingZones()
        }
        
        if(self.customObservable != nil){
            self.customObservable?.dispose()
        }
    }
    
}
