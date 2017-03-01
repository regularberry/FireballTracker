//
//  FireballDataManager.swift
//  FireballTracker
//
//  Created by Sean Berry on 3/1/17.
//  Copyright © 2017 Sean Berry. All rights reserved.
//

import Foundation
import CoreData

struct FireballDataManager {
    
    let container: NSPersistentContainer
    
    init() {
        self.container = NSPersistentContainer(name: "FireballTracker")
        self.container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func allExistingFireballs() -> [FireballMO] {
        let fetch = NSFetchRequest<FireballMO>(entityName: "Fireball")
        do {
            let fireballs = try container.viewContext.fetch(fetch)
            return fireballs
        } catch let error {
            print(error.localizedDescription)
        }
        return []
    }
    
    func save(jsonFireballs: [FireballJSON]) {
        for fireball in jsonFireballs {
            let ballMO = NSEntityDescription.insertNewObject(forEntityName: "Fireball", into: container.viewContext) as! FireballMO
            ballMO.date = fireball.date as NSDate
            ballMO.latitude = fireball.latitude
            ballMO.longitude = fireball.longitude
        }
        
        saveContext()
    }
    
    func replaceAllFireballs(with jsonFireballs: [FireballJSON]) {
        let fireballs = allExistingFireballs()
        for fireball in fireballs {
            container.viewContext.delete(fireball)
        }
        save(jsonFireballs: jsonFireballs)
    }
    
    private func saveContext() {
        do {
            try container.viewContext.save()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
