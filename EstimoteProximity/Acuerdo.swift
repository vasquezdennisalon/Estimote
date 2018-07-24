//
//  Acuerdo.swift
//  aupar
//
//  Created by Javier Cifuentes on 6/20/17.
//  Copyright © 2017 aritec-la. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class AcuerdoController{
    static let shared = AcuerdoController()
    
    /*
     Agrega un acuerdo, si la operacion es exitosa, devuelve el acuerdo, de lo contrario devuelve nil
     */
    public func add(id:String,
                    personalizacion:JSON,
                    logo:String,
                    setDefault:Bool = true)->Acuerdo?{
        let acuerdo = Acuerdo()
        acuerdo.id = id.lowercased()
        acuerdo.color = personalizacion["color"].stringValue
        acuerdo.logo = logo
        do{
            try Api.shared.realm.write{
                Api.shared.realm.add(acuerdo)
            }
            if(setDefault){
                Api.shared.currentAcuerdo = acuerdo
            }
            return acuerdo
        }catch{
            print("DB ERROR: Adding\nACUERDO:\(id)")
            return nil
        }
    }
    
    /*
     Actualiza el acuerdo, si la operacion es exitosa devuelve el acuerdo de lo contrario devuelve nil
     */
    public func update(id:String,
                       personalizacion:JSON,
                       logo:String,
                       setDefault:Bool = false)->Acuerdo?{
        
        if let acuerdo = self.get(id: id.lowercased()){
            do{
                try Api.shared.realm.write{
                    acuerdo.color = personalizacion["color"].stringValue
                    acuerdo.aEliminar = false
                    acuerdo.logo = logo
                }
                if(setDefault){
                    Api.shared.currentAcuerdo = acuerdo
                }
                return acuerdo
            }catch{
                print("DB ERROR: Updating\nACUERDO:\(id)")
                return nil
            }
        }else{
            return nil
        }
    }
    
    /*
     Chequea si el acuerdo existe
     */
    public func exists(id:String)->Bool{
        let id_s = id.lowercased()
        let predicate = NSPredicate(format: "id == %@", id_s)
        let results = Api.shared.realm.objects(Acuerdo.self).filter(predicate)
        if(results.count>0){
            return true
        }else{
            return false
        }
    }
    
    /*
     Devuelve el acuerdo, si existe, de lo contrario devuelve nil
     */
    func get(id:String)->Acuerdo?{
        let id_s = id.lowercased()
        let predicate = NSPredicate(format: "id == %@", id_s)
        let results = Api.shared.realm.objects(Acuerdo.self).filter(predicate)
        if (results.count>0){
            return results.first
        }else{
            return nil
        }
    }
    
    func getFromImplementacion(id:String, completion: @escaping (Acuerdo?, Bool)->Void){
        if let implementacion = ImplementacionController.shared.get(id:id){
            let parameters = ["implementationId": implementacion.id!]
            /*Api.shared.Get(url: "implementations", parameters: parameters){
            //Api.shared.Post(url: "implementations", parameters: parameters){
                response in
                if(response.response?.statusCode == 200){
                    let json_implementacion = JSON(response.result.value)
                    let acuerdo_json = json_implementacion["acuerdo"]
                    let acuerdo_id = acuerdo_json["id"].stringValue
                    let personalizacion = acuerdo_json["personalizacion"]
                    let logo = acuerdo_json["logo"].stringValue
                    if !AcuerdoController.shared.exists(id: acuerdo_id){
                        if let acuerdo = AcuerdoController.shared.add(id: acuerdo_id, personalizacion: personalizacion,logo:logo, setDefault:false){
                            do{
                                try Api.shared.realm.write{
                                    //implementacion.acuerdo = acuerdo
                                }
                                completion(acuerdo, true)
                            }catch{
                                completion(acuerdo,false)
                            }
                        }else{
                            completion(nil,false)
                        }
                    }else{
                        if let acuerdo = AcuerdoController.shared.update(id: acuerdo_id, personalizacion: personalizacion, logo: logo){
                            do{
                                try Api.shared.realm.write{
                                    //implementacion.acuerdo = acuerdo
                                }
                                completion(acuerdo,true)
                            }catch{
                                completion(acuerdo,false)
                            }
                        }else{
                            completion(nil,false)
                        }
                    }
                }else{
                    completion(nil,false)
                }
            }*/
        }else{
            completion(nil,false)
        }
    }
}

class Acuerdo:Object {
    
    @objc dynamic var id: String?
    @objc dynamic var color: String?
    @objc dynamic var aEliminar:Bool = false
    private let implementaciones = List<Implementacion>()
    /*V2*/
    @objc dynamic var logo: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    //Operaciones con Implementaciones
    public func addImplementacion(Implementacion: Implementacion)-> Bool{
        let predicate = NSPredicate(format: "id == %@", Implementacion.id!)
        if(self.implementaciones.index(matching: predicate) == nil){
            self.implementaciones.append(Implementacion)
            return true
        }
        return false
    }
    
    public func removeImplementacion(implementacion: Implementacion) ->Bool{
        let predicate = NSPredicate(format: "id == %@", implementacion.id!)
        let rs = self.implementaciones.index(matching: predicate)
        if( rs != nil){
            self.implementaciones.remove(at: rs!)
            return true
        }
        return false
    }
    
}
