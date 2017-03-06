//
//  FireballDataStack.swift
//  FireballTracker
//
//  Created by Sean Berry on 3/1/17.
//  Copyright © 2017 Sean Berry. All rights reserved.
//

import Foundation
import CoreData

/// Handles persistance and retrieval of local fireball data
struct FireballDataStack {
    
    let container: NSPersistentContainer

    /**
        parameter inMemory: setting to true will disable persistence. Useful for testing
    */
    init(inMemory: Bool = false) {
        self.container = NSPersistentContainer(name: "FireballTracker")
        
        if inMemory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            self.container.persistentStoreDescriptions = [description]
        }        
    }
    
    /// Loads existing local data (if any)
    func loadStore(completion block: @escaping (NSPersistentStoreDescription, Error?) -> Void) {
        container.loadPersistentStores(completionHandler: block)
    }
    
    /// Returns all existing local fireballs (if any)
    func allExistingFireballs() -> [FireballMO] {
        let fetch = NSFetchRequest<FireballMO>(entityName: "Fireball")
        fetch.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        do {
            let fireballs = try container.viewContext.fetch(fetch)
            return fireballs
        } catch let error {
            print(error.localizedDescription)
        }
        return []
    }
    
    /// Saves FireballJSON fireballs to be retrieved later
    func save(jsonFireballs: [FireballJSON]) {
        for fireball in jsonFireballs {
            if isUnique(fireball: fireball) {
                let ballMO = NSEntityDescription.insertNewObject(forEntityName: "Fireball", into: container.viewContext) as! FireballMO
                ballMO.date = fireball.date as NSDate
                ballMO.latitude = fireball.latitude
                ballMO.longitude = fireball.longitude
                saveContext()
            }
        }
    }
    /// Deletes all existing fireballs and saves the new ones afterwards
    func replaceAllFireballs(with jsonFireballs: [FireballJSON]) {
        let fireballs = allExistingFireballs()
        for fireball in fireballs {
            container.viewContext.delete(fireball)
        }
        save(jsonFireballs: jsonFireballs)
    }
    
    private func saveContext() {
        guard container.viewContext.hasChanges else {
            return
        }
        
        do {
            try container.viewContext.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func isUnique(fireball: FireballJSON) -> Bool {
        let fetch = NSFetchRequest<FireballMO>(entityName: "Fireball")
        let predicate = NSPredicate(format: "date==%@ AND longitude==%@ AND latitude==%@", fireball.date as NSDate, fireball.longitude as NSNumber, fireball.latitude as NSNumber)
        fetch.predicate = predicate
        do {
            let fireballs = try container.viewContext.fetch(fetch)
            return fireballs.count == 0
        } catch let error {
            print(error.localizedDescription)
        }
        return false
    }
}
