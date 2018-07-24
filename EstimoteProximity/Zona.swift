//
//  Zona.swift
//  aupar
//
//  Created by Javier Cifuentes on 5/14/18.
//  Copyright © 2018 aritec-la. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class ZonaController{
    static let shared = ZonaController()
    public func add(id:String, distancia:Double, nombre:String, implementacion:Implementacion)->Zona?{
        let zona = Zona()
        zona.id = id.lowercased()
        zona.distancia.value = distancia
        zona.nombre = nombre
        do{
            try Api.shared.realm.write{
                Api.shared.realm.add(zona)
                implementacion.addZona(Zona: zona)
            }
            return zona
        }catch{
            print("DB ERROR: Adding\nZona:\(id) Distancia:\(distancia)")
            return nil
        }
    }
    
    func update(id:String, distancia:Double, nombre:String,implementacion:Implementacion)->Zona?{
        if let zona = self.get(id:id.lowercased()){
            do{
                try Api.shared.realm.write{
                    zona.distancia.value = distancia
                    zona.aEliminar = false
                    zona.nombre = nombre
                }
                return zona
            }catch{
                print("DB ERROR: Updating\nZONA:\(id) Distancia:\(distancia)")
                return nil
            }
        }else{
            return nil
        }
    }
    
    func exists(id:String)->Bool{
        let id_s = id.lowercased()
        let predicate = NSPredicate(format: "id == %@", id_s)
        let results = Api.shared.realm.objects(Zona.self).filter(predicate)
        if(results.count>0){
            return true
        }else{
            return false
        }
    }
    
    func get(id:String)->Zona?{
        let id_s = id.lowercased()
        let predicate = NSPredicate(format: "id == %@", id_s)
        let results = Api.shared.realm.objects(Zona.self).filter(predicate)
        if results.count>0{
            return results.first
        }else{
            return nil
        }
    }
}


class Zona:Object {
    @objc dynamic var id:String?
    @objc dynamic var nombre:String?
    let distancia = RealmOptional<Double>()
    @objc dynamic var aEliminar: Bool = false
    let beacons = List<AuparBeacon>()
    
    @objc dynamic var implementacion:Implementacion?{
        set{
            newValue?.addZona(Zona: self)
        }
        get{
            if (self._implementacion.count>0){
                return self._implementacion.first
            }else{
                return nil
            }
        }
    }
    private let _implementacion = LinkingObjects(fromType: Implementacion.self, property: "zonas")
    
    public func addBeacon(AuparBeacon: AuparBeacon)-> Bool{
        let predicate = NSPredicate(format: "id == %@", AuparBeacon.id!)
        if(self.beacons.index(matching: predicate) == nil){
            self.beacons.append(AuparBeacon)
            return true
        }
        return false
    }
    
    public func removeBeacon(AuparBeacon: AuparBeacon) ->Bool{
        let predicate = NSPredicate(format: "id == %@", AuparBeacon.id!)
        let rs = self.beacons.index(matching: predicate)
        if( rs != nil){
            self.beacons.remove(at: rs!)
            return true
        }
        return false
    }
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["implementacion"]
    }
}
