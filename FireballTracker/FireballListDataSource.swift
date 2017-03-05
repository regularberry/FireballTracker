//
//  FireballListDataSource.swift
//  FireballTracker
//
//  Created by Sean Berry on 3/4/17.
//  Copyright © 2017 Sean Berry. All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum DataSourceError: Error {
    case completelyConsumed
}

class FireballListDataSource: NSObject, UITableViewDataSource {
    
    public typealias LoadDataHandler = (Error?) -> Void
    
    let dataManager: FireballDataManager
    let apiClient: FireballApiClient
    var fetchedDelegate: NSFetchedResultsControllerDelegate?
    var fetchedResultsController: NSFetchedResultsController<FireballMO>?
    var possiblyMoreData = true
    
    init(fetchedDelegate: NSFetchedResultsControllerDelegate? = nil, dataManager: FireballDataManager = FireballDataManager(), apiClient: FireballApiClient = FireballApiClient()) {
        self.fetchedDelegate = fetchedDelegate
        self.dataManager = dataManager
        self.apiClient = apiClient
    }
    
    func loadData(completionHandler: @escaping LoadDataHandler) {
        dataManager.loadStore(completion: {(description, error) in
            guard error == nil else {
                completionHandler(error!)
                return
            }
            
            let fetch = NSFetchRequest<FireballMO>(entityName: "Fireball")
            fetch.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            
            self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: self.dataManager.container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            self.fetchedResultsController?.delegate = self.fetchedDelegate
            
            do {
                try self.fetchedResultsController?.performFetch()
                completionHandler(nil)
            } catch let error {
                completionHandler(error)
            }
        })
    }
    
    func refreshData(completionHandler: @escaping LoadDataHandler) {
        apiClient.getLatestFireballs(completion: { (jsonFireballs, error) in
            
            guard error == nil else {
                completionHandler(error!)
                return
            }
            
            guard jsonFireballs.count > 0 else {
                self.possiblyMoreData = false
                completionHandler(DataSourceError.completelyConsumed)
                return
            }
            
            self.dataManager.replaceAllFireballs(with: jsonFireballs)
            completionHandler(nil)
        })
    }
    
    func getOlderData() {
        guard let oldestDate = getOldestDate() else {
            return
        }
        
        apiClient.getFireballs(beforeDate: oldestDate, completion: { (jsonFireballs, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard jsonFireballs.count > 0 else {
                return
            }
            
            self.dataManager.save(jsonFireballs: jsonFireballs)
        })
    }
    
    func getOldestDate() -> Date? {
        let fireballs = dataManager.allExistingFireballs()
        guard let last = fireballs.last else {
            return nil
        }
        return last.swiftDate
    }
    
    func noFireballs() -> Bool {
        guard let fetched = fetchedResultsController?.fetchedObjects else {
            print("No fireballs? We haven't tried to fetch them yet.")
            return true
        }
        return fetched.count == 0
    }
    
    func fireball(at indexPath: IndexPath) -> FireballMO? {
        if let controller = fetchedResultsController {
            return controller.object(at: indexPath)
        }
        return nil
    }
    
    // MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController?.sections else {
            return 0
        }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let extraRow = possiblyMoreData ? 1 : 0
        return numberOfRows(inSection: section) + extraRow
    }
    
    func numberOfRows(inSection: Int = 0) -> Int {
        guard let sections = fetchedResultsController?.sections else {
            return 0
        }
        
        guard inSection < sections.count else {
            return 0
        }
        
        return sections[inSection].numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == numberOfRows(inSection: 0) {
            let activityCell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell")!
            return activityCell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayCell", for: indexPath) as! DayCell
        if let fireball = fireball(at: indexPath) {
            cell.fireball = fireball
        }
        return cell
    }
}
