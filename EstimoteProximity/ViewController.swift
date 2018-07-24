//
//  ViewController.swift
//  EstimoteProximity
//
//  Created by Denis Vásquez on 7/11/18.
//  Copyright © 2018 Denis Vásquez. All rights reserved.
//

import UIKit
import EstimoteProximitySDK
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    

    /*
     * Declaring Variables
     */
    static let shared = EstimoteManager()
    var auparObserver: EPXProximityObserver!
    var observing = false
    //var paises: Array<Countries> = []
    var implementations: Array<BeaconStruct.BeaconsJson> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.getBeaconsJson()
        //ImplementationProvider.shared.getBeaconsJson()
        
        //let data:ImplementationProvider = ImplementationProvider()
        //data.getBeaconsJson()
        //let i:Implementation = data.FindByBeaconId(Id: "d515d0113e06c64d7cf49245074bec3f")
        
        
        
        var pObserver:EPXProximityObserver?
        
        let credentials = EPXCloudCredentials(appID: "aupar-ios-cbx", appToken: "51cf40fce50dd285efa57e30e6a91631")
        pObserver = EPXProximityObserver(credentials: credentials, errorBlock: {error in
            print("ERROR OBSERVER: dynamic \n ERROR: \(error)")
        })
        var currentImplementation:Implementation?
        var sectorScanner:SectorScanner?
        print(currentImplementation)
        
        let implementationScanner = ImplementationScanner(estimoteProximityObserver: pObserver!, attachmentKey: "AuparDefaultZone", attachmentValue: "AuparDefaultZone", distance: 0.2)
        
        implementationScanner.throttle(0.4, scheduler: MainScheduler.instance).subscribe(
            onNext:{
                beacon in
                print("Esta llegando a este beacon \(String(describing: beacon.Id)) type: \(String(describing: beacon.type))")
                ImplementationProvider.shared.getBeaconsJson()
                let implementation:Implementation? = ImplementationProvider.shared.FindByBeaconId(Id: beacon.Id!)!
                if(currentImplementation == nil || currentImplementation?.getId() != implementation?.getId()){
                    currentImplementation = implementation
                    
                    if(sectorScanner != nil){
                        sectorScanner?.dispose()
                    }
                    print("llega implementación \(currentImplementation)")
                    sectorScanner = SectorScanner(estimoteProximityObserver: pObserver!, implementation: currentImplementation!)
                    sectorScanner?.throttle(0.4, scheduler: MainScheduler.instance).subscribe(onNext:{
                        sectorDetect in
                        print("DETECTO SECTOR \(sectorDetect)")
                    })
                    
                }
            }
        )
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func activeDynamics(_ sender: Any) {
        EstimoteManager.shared.stop()
        EstimoteManager.shared.stopDynamicObserver()
        EstimoteManager.shared.addDynamicZone()
        EstimoteManager.shared.startDynamic()
    }
}

