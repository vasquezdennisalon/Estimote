//
//  Implementacion.swift
//  aupar
//
//  Created by Javier Cifuentes on 6/20/17.
//  Copyright © 2017 aritec-la. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

class ImplementacionController{
    static let shared = ImplementacionController()
    
    /*
     Crea una implementación y se la agrega al acuerdo y devuelve dicha implementacion si fue creada correctamente
     */
    public func add(id:String,
                    acuerdo:Acuerdo)->Implementacion?{
        
        let implementacion = Implementacion()
        implementacion.id = id.lowercased()
        do{
            try Api.shared.realm.write{
                Api.shared.realm.add(implementacion)
                acuerdo.addImplementacion(Implementacion: implementacion)
            }
            Api.shared.currentImplementacion = implementacion
            return implementacion
        }catch{
            return nil
        }
    }
    
    /*
     Actualiza la informacion de la implementacion, si la operacion es exitosa devuelve la implementacion, de lo contrario devuelve nil
     */
    public func update(id:String,acuerdo:Acuerdo)->Implementacion?{
        if let implementacion = self.get(id:id.lowercased()){
            do{
                try Api.shared.realm.write{
                    implementacion.aEliminar = false
                }
                return implementacion
            }catch{
                return nil
            }
        }else{
            return nil
        }
    }
    
    /*
     Crea una implementacion sin acuerdo
     */
    public func add(id:String, name:String, setDefault:Bool = true)->Implementacion?{
        let implementacion = Implementacion()
        implementacion.id = id.lowercased()
        implementacion.nombre = name
        do{
            try Api.shared.realm.write{
                Api.shared.realm.add(implementacion, update: true)
            }
            if (setDefault){
                Api.shared.currentImplementacion = implementacion
            }
            return implementacion
        }catch{
            return nil
        }
    }
    
    /*
    Chequea si la implementacion existe
     */
    func exists(id:String)->Bool{
        let id_s = id.lowercased()
        let predicate = NSPredicate(format: "id == %@", id_s)
        let results = Api.shared.realm.objects(Implementacion.self).filter(predicate)
        if(results.count>0){
            return true
        }else{
            return false
        }
    }

    /*
     Devuelve la implementacion si existe, de lo contrario devuelve nil
     */
    func get(id:String)->Implementacion?{
        let id_s = id.lowercased()
        let predicate = NSPredicate(format: "id == %@", id_s)
        let results = Api.shared.realm.objects(Implementacion.self).filter(predicate)
        if results.count > 0{
            return results.first
        }else{
            return nil
        }
    }
    
    /*
    Devuelve la implementacion de la interaccion
    */
    /*func getFromInteraccion(interaccionId:String, completion: @escaping(Implementacion?, Bool)->Void){
        if let objeto = InteraccionController.shared.get(id: interaccionId){
            if let implementacion = objeto.implementacion{
                if let acuerdo = implementacion.acuerdo{
                    completion(implementacion,true)
                }else{
                    AcuerdoController.shared.getFromImplementacion(id: implementacion.id!){
                        acuerdo, completo in
                        if completo{
                            completion(implementacion, true)
                        }else{
                            completion(implementacion,false)
                        }
                    }
                }
            }else{
                completion(nil,false)
            }
        }else{
            completion(nil,false)
        }
    }*/
    
    /*
    Devuelve la implementacion de la pauta
    */
    /*func getFromPauta(pautaId:String, completion: @escaping (Implementacion?, Bool)->Void){
        if let pauta = PautaController.shared.get(id: pautaId){
            if let implementacion = pauta.implementacion{
                if let acuerdo = implementacion.acuerdo{
                    completion(implementacion,true)
                }else{
                    AcuerdoController.shared.getFromImplementacion(id: implementacion.id!){
                        acuerdo, completo in
                        if(completo){
                            completion(implementacion,true)
                        }else{
                            completion(implementacion,false)
                        }
                    }
                }
            }else{
               completion(nil,false)
            }
        }else{
            completion(nil,false)
        }
    }*/
    
}

class Implementacion:Object {
    
    
    @objc dynamic var id: String?
    @objc dynamic var nombre: String?
    @objc dynamic var aEliminar: Bool = false
    
    @objc dynamic var acuerdo:Acuerdo?{
        set{
            newValue?.addImplementacion(Implementacion: self)
        }
        get{
            return self._acuerdo.first
        }
    }
    private let _acuerdo = LinkingObjects(fromType: Acuerdo.self, property: "implementaciones")
    
    let zonas = List<Zona>()
    //let pautas = List<Pauta>()
    //let interacciones = List<Interaccion>()
    //let productos = List<Producto>()
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    override static func ignoredProperties() -> [String] {
        return ["acuerdo"]
    }
    
    //Operaciones con Zonas
    public func addZona(Zona:Zona) -> Bool{
        let predicate = NSPredicate(format: "id == %@", Zona.id!)
        if (self.zonas.index(matching:predicate) == nil){
            self.zonas.append(Zona)
            return true
        }
        return false
    }
    
    public func removeZona(Zona:Zona) ->Bool{
        let predicate = NSPredicate(format: "id == %@", Zona.id!)
        let rs = self.zonas.index(matching: predicate)
        if( rs != nil){
            self.zonas.remove(at: rs!)
            return true
        }
            return false
    }
    
    //Operaciones con Pautas
    /*public func addPauta(Pauta: Pauta)-> Bool{
        let predicate = NSPredicate(format: "id == %@", Pauta.id!)
        if(self.pautas.index(matching: predicate) == nil){
            self.pautas.append(Pauta)
            return true
        }
        return false
    }
    
    public func removePauta(Pauta: Pauta) ->Bool{
        let predicate = NSPredicate(format: "id == %@", Pauta.id!)
        let rs = self.pautas.index(matching: predicate)
        if( rs != nil){
            self.pautas.remove(at: rs!)
            return true
        }
        return false
    }*/
    
    //Operaciones con Interacciones
    /*public func addInteraccion(Interaccion: Interaccion)-> Bool{
        let predicate = NSPredicate(format: "id == %@", Interaccion.id!)
        if(self.interacciones.index(matching: predicate) == nil){
            self.interacciones.append(Interaccion)
            return true
        }
        return false
    }
    
    public func removeInteraccion(Interaccion: Interaccion) ->Bool{
        let predicate = NSPredicate(format: "id == %@", Interaccion.id!)
        let rs = self.interacciones.index(matching: predicate)
        if( rs != nil){
            self.interacciones.remove(at: rs!)
            return true
        }
        return false
    }*/
    
    //Operaciones con Productos
    /*public func addProducto(Producto: Producto)-> Bool{
        let predicate = NSPredicate(format: "id == %@", Producto.id!)
        if(self.productos.index(matching: predicate) == nil){
            self.productos.append(Producto)
            return true
        }
        return false
    }
    
    public func removeProducto(Producto: Producto) ->Bool{
        let predicate = NSPredicate(format: "id == %@", Producto.id!)
        let rs = self.productos.index(matching: predicate)
        if( rs != nil){
            self.productos.remove(at: rs!)
            return true
        }
        return false
    }*/
    
   
    


}
