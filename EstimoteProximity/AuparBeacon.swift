//
//  AuparBeacon.swift
//  aupar
//
//  Created by Javier Cifuentes on 6/20/17.
//  Copyright © 2017 aritec-la. All rights reserved.
//

import Foundation
import RealmSwift

class AuparBeaconController{
    static let shared = AuparBeaconController()
    
    /*
     Chequea si el beacon existe utilizando el uuid, major y minor
     */
    func exists(uuid:String, major:Int, minor:Int)->Bool{
        let predicate = NSPredicate(format: "uuid == %@ && major == %d && minor == %d",uuid,major,minor)
        let results = Api.shared.realm.objects(AuparBeacon.self).filter(predicate)
        if results.count > 0{
            return true
        }else{
            return false
        }
    }
    
    /*
    Chequea si el beacon más cercano existe
     */
    func closesBeaconExists()->Bool{
        /*if let beacon = EstimoteManager.shared.closestBeacon{
            return exists(uuid: beacon.proximityUUID.uuidString.lowercased(),major: Int(beacon.major),minor:Int(beacon.minor))
        }else{
            return false
        }*/
        return false
    }
    
    /*
     Obtiene el beacon, si existe, de lo contrario devuleve nil
     */
    func get(id:String)->AuparBeacon?{
        let id_s = id.lowercased()
        let predicate = NSPredicate(format: "id == %@", id_s)
        let results = Api.shared.realm.objects(AuparBeacon.self).filter(predicate)
        if results.count>0{
            return results.first
        }else{
            return nil
        }
    }
    
    /*
     Obtiene el beacon, si existe, de lo contrario devuleve nil
     */
    func get(uuid:String, major:Int, minor:Int)->AuparBeacon?{
        let predicate = NSPredicate(format: "uuid == %@ && major == %d && minor == %d",uuid,major,minor)
        let results = Api.shared.realm.objects(AuparBeacon.self).filter(predicate)
        if results.count > 0{
            return results.first
        }else{
            return nil
        }
    }
    
    /*
     Crea el beacon y se lo agrega la implementacion, si la operacion es exitosa, devuelve el beacon, de lo contrario devuelve nil
     */
    func add(id: String, uuid: String, major: Int, minor: Int, zona:Zona, canje:Bool)->AuparBeacon?{
        let beacon = AuparBeacon()
        beacon.id = id.lowercased()
        beacon.uuid = uuid.lowercased()
        beacon.major = major
        beacon.minor = minor
        beacon.canje = canje
        do{
            try Api.shared.realm.write{
                Api.shared.realm.add(beacon)
                zona.addBeacon(AuparBeacon: beacon)
            }
            return beacon
        }catch{
            print("DB ERROR: Adding\nBEACON:\(id) UUID:\(uuid) Major:\(major) Minor:\(minor)")
            return nil
        }
    }
    
    /*
     Actualiza la informacion de un beacon, si la operacion es exitosa, devuelve el beacon, de lo contrario devuelve nil
     */
    func update(id: String, uuid: String, major: Int, minor: Int, zona:Zona, canje:Bool)->AuparBeacon?{
        if let beacon = self.get(id:id.lowercased()){
            do{
                try Api.shared.realm.write{
                    beacon.uuid = uuid.lowercased()
                    beacon.major = major
                    beacon.minor = minor
                    beacon.canje = canje
                    beacon.aEliminar = false
                }
                return beacon
            }catch{
                print("DB ERROR: Updating\nBEACON:\(id) UUID:\(uuid) Major:\(major) Minor:\(minor)")
                return nil
            }
        }else{
            return nil
        }
    }
    
    /*
     Chequea si el beacon existe utilizando el id
     */
    func exists(id:String)->Bool{
        let id_s = id.lowercased()
        let predicate = NSPredicate(format: "id == %@", id_s)
        let results = Api.shared.realm.objects(AuparBeacon.self).filter(predicate)
        if(results.count>0){
            return true
        }else{
            return false
        }
    }
    
    /*
     Chequea si el beacon pertenece a esta zona
     */
    func beaconInZona(uuid:String,major:Int,minor:Int,zonaId:String)->Bool{
        if(ZonaController.shared.exists(id: zonaId)){
            if(self.exists(uuid: uuid, major: major, minor: minor)){
                if let zona = ZonaController.shared.get(id: zonaId), let beacon = self.get(uuid:uuid, major:major, minor:minor){
                    if (zona.beacons.contains(beacon)){
                        return true
                    }else{
                        return false
                    }
                }else{
                    return false
                }
            }else{
                return false
            }
        }else{
            return false
        }
    }
    
    
}

class AuparBeacon:Object {
    @objc dynamic var id: String?
    @objc dynamic var major: Int = 0
    @objc dynamic var minor: Int = 0
    @objc dynamic var nombre: String?
    @objc dynamic var uuid: String?
    @objc dynamic var aEliminar: Bool = false
    /* V2*/
    @objc dynamic var canje: Bool = false
    @objc dynamic var zona:Zona?{
        set{
            newValue?.addBeacon(AuparBeacon: self)
        }
        get{
            if(self._zona.count > 0){
                return self._zona.first
            }else{
                return nil
            }
        }
    }
    private let _zona = LinkingObjects(fromType: Zona.self, property:"beacons")
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["zona"]
    }
    
    
    
}
