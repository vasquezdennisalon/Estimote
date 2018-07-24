//
//  Api.swift
//  aupar
//
//  Created by Javier Cifuentes on 4/7/17.
//  Copyright © 2017 aritec-la. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import AlamofireImage
import RealmSwift
import AVFoundation
import PopupDialog
import StyleDecorator
import PKHUD
import RxSwift

class Configuracion:Object{
    @objc dynamic var key: String = ""
    @objc dynamic var value: String = ""
}


enum AppState{
    case open
    case background
    case loaded
    case closed
}

enum AppEnvironment{
    case testing
    case development
    case certification
    case production
}

class Api: NSObject{
    static let shared = Api()
    var installId:String = ""
    var debug = true
    var overrideInit = false
    var offline = false
    ///////////////////VARIABLES DE AMBIENTE/////////////////////////////
    let version = "v1.1"
    let aupar_base:String = "https://mobile.aupar.gt/"
    let aupar_router:String = "https://mobile.aupar.gt/api/endpoints"//Servicio que se llama para saber los endpoints
    var environment:AppEnvironment = .development
    ///Estas variables cambian dependiendo del ambiente en que se este///
    
    var api_url:String = ""
    var issuer:String = ""
    var scopes:[String] = ["openid", "profile", "offline_access", "email", "WebMobileAPI"]
    let openid_client:String = "mobile_client_oauth"
    let redirect_url:String = "com.aritec-la.aupar:/oauthredirect"
    ////////////////////////////////////////////////////////////////////
    
    ///////////////VARIABLES DEL SERVICIO DE CONFIGURACION//////////////
    var aupar_uuid_json:String?
    var configs_json:String?
    var config_type:Int = 0
    var virtualMajor:Int = 0
    var virtualMinor:Int = 0
    var auparId:UUID?
    var beaconRegions = [BeaconID]()
    var supportEmail:String = "developer@aupar.gt"
    var normal_cdn:String = "https://cdn-ma.azureedge.net/api/\(version)/"
    var video_cdn:String = "https://cdn-vma.azureedge.net/api/\(version)/"
    ///////////////////////////////////////////////////////////////////
    
    
    ////////////VARIABLES DE LOS REPORTES DE ESTIMOTE/////////////////
    var telemetry_reporting:Bool = false
    var analitycs_reporting:Bool = false
    var secure_monitoring:Bool = false
    /////////////////////////////////////////////////////////////////
    
    //application state
    var open = false
    var background =  false
    var showed = false
    
    var loaded = false
    var canQuery = false
    /////////////VARIABLES QUE MANTIENEN EL MODO CAMALEON//////////////
    var realm = try! Realm() //Mantiene la base de datos compartida
    var currentAcuerdo:Acuerdo? //Mantiene el acuerdo actual con sus colores
    var currentBeacon:AuparBeacon? //Mantiene el beacon actual
    var currentImplementacion:Implementacion? //Mantiene la implementación actual
    var currentImplementacionCompleted = PublishSubject<Implementacion>()
    /////////////////////////////////////////////////////////////////
    
    ///////////IMAGE CACHE///////////////////////////////////////////
    let imageCache = AutoPurgingImageCache()
    /////////////////////////////////////////////////////////////////
    override init(){
        super.init()
    }
    

    
    func clearDB(){
        clearVars()
        //delete interacciones
        //delete pautas
        //delete beacons
        clearBeacons()
        //productos
        //delete implementacion
        clearImplementaciones()
        //delete acuerdos
        clearAcuerdos()
        //delete gustos
        //delete pautas
        //delete beacons
        processClearBeacons()
        //productos
        //delete implementacion
        processClearImplementaciones()
        //delete acuerdos
        processClearAcuerdos()
        //delete gustos
        print("Cleared Database")
    }
    func clearVars(){
        self.currentBeacon = nil
        self.currentAcuerdo = nil
        self.currentImplementacion = nil
    }

    func processClearConquistados(){
        
    }
    
    func clearBeacons(){
        let beacons = realm.objects(AuparBeacon.self)
        for beacon in beacons {
            try! realm.write {
                beacon.aEliminar = true
            }
        }
    }
    func processClearBeacons(){
        let predicate = NSPredicate(format: "aEliminar == true")
        let beacons = realm.objects(AuparBeacon.self).filter(predicate)
        for beacon in beacons {
            try! realm.write {
                realm.delete(beacon)
            }
        }
    }

    
    func clearZonas(){
        let zonas = realm.objects(Zona.self)
        for zona in zonas{
            try! realm.write {
                zona.aEliminar = true
            }
        }
    }
    
    func processClearZonas(){
        let predicate = NSPredicate(format: "aEliminar == true")
        let zonas = realm.objects(Zona.self).filter(predicate)
        for zona in zonas{
            try! realm.write {
                realm.delete(zona)
            }
        }
    }
    
    func clearImplementaciones(){
        let implementaciones = realm.objects(Implementacion.self)
        for implementacion in implementaciones{
            try! realm.write {
                implementacion.aEliminar = true
            }
        }
    }
    func processClearImplementaciones(){
        let predicate = NSPredicate(format: "aEliminar == true")
        let implementaciones = realm.objects(Implementacion.self).filter(predicate)
        for implementacion in implementaciones{
            try! realm.write {
                realm.delete(implementacion)
            }
        }
    }
    
    func clearAcuerdos(){
        let acuerdos = realm.objects(Acuerdo.self)
        for acuerdo in acuerdos{
            try! realm.write {
                acuerdo.aEliminar = true
            }
        }
    }
    
    func processClearAcuerdos(){
        let predicate = NSPredicate(format: "aEliminar == true")
        let acuerdos = realm.objects(Acuerdo.self).filter(predicate)
        for acuerdo in acuerdos{
            try! realm.write {
                realm.delete(acuerdo)
            }
        }
    }

    func getDebugText()->String{
        if self.debug == true
        {
            return "ON"
            
        }else{
            return "OFF"
        }
        
    }
    
    
    
    
}
