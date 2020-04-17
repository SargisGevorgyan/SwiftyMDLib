//
//  CodableManager.swift
//
//  Copyright © 2019 MagicDevs. All rights reserved.
//

import UIKit
import CoreData


open class CodableManager {
    public static var STORAGENAME = "SavedCodable"
    public static let shared = CodableManager()
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    private var persistentController = PersistentController(containerName: CodableManager.STORAGENAME)
    
    private init() {
    }
    
    open func saveModelFor<T:Codable>(key:String, model: T, isKeepingPermonantly: Bool = false) {
        let data = try? encoder.encode(model)
        if let object = getFromDB(key: getKeyFor(key)) {
            object.data = data
        } else {
            let context = persistentController.viewContext
            let object = StoredModel(context: context)
            object.key = getKeyFor(key)
            object.data = data
            object.isKeepingPermonantly = isKeepingPermonantly
        }
        
        persistentController.saveViewContext()
    }
    
    open func saveStringFor(key:String, value: String? ) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
    }
    
    open func getStringFor(key: String) -> String? {
        let defaults = UserDefaults.standard
        let value = defaults.string(forKey: key)
        return value
    }
    
    open func saveModelInUserDefaultsFor<T:Codable>(key:String, model:T) {
        do {
            let encoded = try encoder.encode(model)
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: key)
        } catch {
            print(error)
        }
    }
    
    open func getModelFromUserDefaults<T:Codable>(key:String) -> T? {
        guard let loadedData = UserDefaults.standard.value(forKey: key) as? Data  else {
                   print("couldn't find data ")
                   return nil
               }
        guard let loadedModel = try? decoder.decode(T.self, from: loadedData)  else {
            return nil
        }
        return loadedModel
    }
    
    open func getModelFor<T: Codable>(key: String) -> T? {
        
        guard let object = getFromDB(key: getKeyFor(key)) else {
            return nil
        }
        if  object.data != nil {
            guard let model = try? decoder.decode(T.self, from: object.data!) else {
                return nil
            }
            return model
        }
        return nil
    }
    
    private func getFromDB(key: String) -> StoredModel? {
        let context = persistentController.viewContext
        let request: NSFetchRequest<StoredModel> = StoredModel.fetchRequest()
        
        request.predicate = NSPredicate(format: "key ==[cd] %@", key)
         let object = try? context.fetch(request)
        return object?.first
    }
    
    open func eraseDB() {
            let context = persistentController.viewContext
            let request: NSFetchRequest<StoredModel> = StoredModel.fetchRequest()
            
            let data = try? context.fetch(request)
            
            for item in data ?? [] {
                if !(item.isKeepingPermonantly) {
                    context.delete(item)
                }
            }
            persistentController.saveContext(context)
    //        persistentController.eraseEntity(.storedModel)
        }
    
    
    open func getKeyFor(_ key: String) -> String {
        return key
    }
    
}
