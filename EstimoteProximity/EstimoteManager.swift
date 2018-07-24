//
//  EstimoteManager.swift
//  EstimoteProximity
//
//  Created by Denis Vásquez on 7/11/18.
//  Copyright © 2018 Denis Vásquez. All rights reserved.
//

import Foundation
import EstimoteProximitySDK
/*
 Key: AuparCustomZone - Value: AuparCustomZone
 Key: AuparDefaultZone - Value: AuparDefaultZone
 */

class EstimoteManager{
    /*
     * Declaring Variables
     */
    static let shared = EstimoteManager()
    var auparObserver: EPXProximityObserver!
    var dynamicObserver: EPXProximityObserver!
    var observing = false
    var dynamic_observing = false
    var dynamicZones = [EPXProximityZone]()
    var implementations: Array<BeaconStruct.BeaconsJson> = []
    
    /*
     * initializing the class EstimoteManager
     */
    init(){
        let credentials = EPXCloudCredentials(appID: "ios-dynamic-zones-test-dt7", appToken: "8e85cef652e08bfe5182d763ea538778")
        self.auparObserver = EPXProximityObserver(credentials: credentials, errorBlock: { error in
            print("Ooops! \(error)")
            self.observing = false
        })
        self.dynamicObserver = EPXProximityObserver(credentials: credentials, errorBlock: {error in
            print("ERROR OBSERVER: dynamic \n ERROR: \(error)")
            self.dynamic_observing = false;
        })
    }
    
    func start(){
        print("Initialize start")
        let auparZone =  EPXProximityZone(range: EPXProximityRange.custom(desiredMeanTriggerDistance: 0.2)!,
                                          attachmentKey: "AuparDefaultZone",
                                          attachmentValue: "AuparDefaultZone")
        auparZone.onEnterAction = {attachment in
            /*let implementation = simulatorWS.shared
            implementation.getImplementation(nameFile: "data2")
            print("data encontrada \(implementation.implementations)")
            let data:Array<BeaconStruct.BeaconsJson> = implementation.FindByBeaconId(BeaconFind: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")
            print("llega la data \(data)")*/
            print("Enter Aupar (custom range)")
            let data = attachment.payload["uuid:major:minor"] as! String
            let attachmentParts = data.components(separatedBy: ":")
            print("\(attachmentParts[0])")
        }
        auparZone.onChangeAction = {attachments in
            print("Change Aupar (custom range)")
            print("\(attachments)")
        }
        auparZone.onExitAction = {attachment in
            print("Exit Aupar (custom range)")
            print("\(attachment)")
        }
        self.auparObserver.startObserving([auparZone])
        self.observing = true
    }
    func stop(){
        print("Initialize stop")
        self.auparObserver.stopObservingZones()
        self.observing = false
    }
    func startDynamic(){
        var _dynamicZones = [EPXProximityZone]()
        for zone in self.dynamicZones{
            zone.onEnterAction = {attachments in
                print("onEnterAction")
                print("\(attachments)")
                print("----------------------------------------------------------------------------------------------------------------------------------------------")
            }
            zone.onChangeAction = {attachments in
                print("onChangeAction")
                print("\(attachments)")
                print("----------------------------------------------------------------------------------------------------------------------------------------------")
            }
            zone.onExitAction = {attachments in
                print("onExitAction")
                print("\(attachments)")
                print("----------------------------------------------------------------------------------------------------------------------------------------------")
            }
            _dynamicZones.append(zone)
        }
        self.dynamicObserver.startObserving(_dynamicZones)
    }
    func stopDynamicObserver(){
        self.dynamicObserver.stopObservingZones()
    }
    func addDynamicZone(){
        var range: Double = 0.2
        var attachmentKey = "AuparCustomZone"
        var attachmentValue = "AuparCustomZone"
        var zone_epx = EPXProximityZone(range: EPXProximityRange.custom(desiredMeanTriggerDistance: range)!, attachmentKey: attachmentKey, attachmentValue: attachmentValue)
        self.dynamicZones.append(zone_epx)
        range = 0.5
        zone_epx = EPXProximityZone(range: EPXProximityRange.custom(desiredMeanTriggerDistance: range)!, attachmentKey: attachmentKey, attachmentValue: attachmentValue)
        self.dynamicZones.append(zone_epx)
    }
    
}
