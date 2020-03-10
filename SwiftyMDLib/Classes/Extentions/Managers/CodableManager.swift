//
//  CodableManager.swift
//  PersonalLawyer
//
//  Created by Davit Ghushchyan on 8/4/19.
//  Copyright © 2019 MagicDevs. All rights reserved.
//

import UIKit
import CoreData

final class CodableManager {
    static let shared = CodableManager()
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    private var persistentController = PersistentController(containerName: "Storage")
    
    private init() {
    }
    
    func saveModelFor<T:Codable>(key:String, model: T) {
        let data = try? encoder.encode(model)
        if let object = getFromDB(key: getKeyFor(key)) {
            object.data = data
        } else {
            let context = persistentController.viewContext
            let object = StoredModel(context: context)
            object.key = getKeyFor(key)
            object.data = data
        }
        persistentController.saveViewContext()
    }
    
    func saveStringFor(key:String, value: String? ) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
    }
    
    func getStringFor(key: String) -> String? {
        let defaults = UserDefaults.standard
        let value = defaults.string(forKey: key)
        return value
    }
    
    func saveModelInUserDefaultsFor<T:Codable>(key:String, model:T) {
        do {
            let encoded = try encoder.encode(model)
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: key)
        } catch {
            print(error)
        }
    }
    
    func getModelFromUserDefaults<T:Codable>(key:String) -> T? {
        guard let loadedData = UserDefaults.standard.value(forKey: key) as? Data  else {
                   print("couldn't find data ")
                   return nil
               }
        guard let loadedModel = try? decoder.decode(T.self, from: loadedData)  else {
            return nil
        }
        return loadedModel
    }
    
    func getModelFor<T: Codable>(key: String) -> T? {
        
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
    
    func eraseDB() {
        persistentController.eraseEntity(.storedModel)
    }
    
    
    func getKeyFor(_ key: String) -> String {
        return key
    }
    
}
