//
//  DataController.swift
//  Virtual Tourist
//
//  Created by Vitaliy Paliy on 10/30/19.
//  Copyright © 2019 PALIY. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    
    let persistentContainer: NSPersistentContainer
    
    init (modelName: String){
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func load(completion: (() -> Void)? = nil ) {
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            guard error == nil else {
                print("Error happened while trying to load Persistent Store.")
                return
            }
            completion?()
        }
    }
    
}
