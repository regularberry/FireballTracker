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

/// completelyConsumed: Thrown when the api isn't returning anymore fireballs before a certain date.
enum DataSourceError: Error {
    case completelyConsumed
}

/** 
 Combines the local data stack with fetching new data from the api.
 
 parameter fetchedDelegate: Receive updates to the local fireball data store
 parameter dataStack: defaults to FireballDataStack(), used for local storage
 parameter apiClient: defaults to FireballApiClient(), used to get new data from the network
 */
class FireballListDataSource: NSObject, UITableViewDataSource {
    
    typealias LoadDataHandler = (Error?) -> Void
    
    let dataStack: FireballDataStack
    let apiClient: FireballApiClient
    var fetchedDelegate: NSFetchedResultsControllerDelegate?
    var fetchedResultsController: NSFetchedResultsController<FireballMO>?
    var possiblyMoreData = true
    
    init(fetchedDelegate: NSFetchedResultsControllerDelegate? = nil, dataStack: FireballDataStack = FireballDataStack(), apiClient: FireballApiClient = ChunkApiClient()) {
        self.fetchedDelegate = fetchedDelegate
        self.dataStack = dataStack
        self.apiClient = apiClient
    }
    
    /// Sets up and retrieves existing local data
    func loadData(completionHandler: @escaping LoadDataHandler) {
        dataStack.loadStore(completion: {(description, error) in
            guard error == nil else {
                completionHandler(error!)
                return
            }
            
            self.loadFetchController()
            
            do {
                try self.fetchedResultsController?.performFetch()
                completionHandler(nil)
            } catch let error {
                completionHandler(error)
            }
        })
    }
    
    private func loadFetchController() {
        let fetch = NSFetchRequest<FireballMO>(entityName: "Fireball")
        fetch.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: self.dataStack.container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchedResultsController?.delegate = self.fetchedDelegate
    }
    
    /// Refreshes local data - used for testing. Please use the fetchedDelegate for your table view.
    func reloadData() {
        do {
            try self.fetchedResultsController?.performFetch()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    /// Grabs the newest fireballs from the api and REPLACES local data
    func getFreshData(completionHandler: @escaping LoadDataHandler) {
        apiClient.getLatestFireballs(completion: { (jsonFireballs, error) in
            
            guard error == nil else {
                completionHandler(error!)
                return
            }
            
            self.dataStack.replaceAllFireballs(with: jsonFireballs)
            completionHandler(nil)
        })
    }
    
    /// Grabs older fireballs and APPENDS local data
    func getOlderData(completionHandler: @escaping LoadDataHandler) {
        guard let oldestDate = getOldestDate() else {
            return
        }
        
        apiClient.getFireballs(beforeDate: oldestDate, completion: { (jsonFireballs, error) in
            guard error == nil else {
                completionHandler(error!)
                return
            }
            
            guard jsonFireballs.count > 0 else {
                self.possiblyMoreData = false
                completionHandler(DataSourceError.completelyConsumed)
                return
            }
            
            self.dataStack.save(jsonFireballs: jsonFireballs)
            completionHandler(nil)
        })
    }
    
    /// Returns: Oldest date from local fireballs
    func getOldestDate() -> Date? {
        let fireballs = dataStack.allExistingFireballs()
        guard let last = fireballs.last else {
            return nil
        }
        return last.swiftDate
    }
    
    /// Do I have any local fireballs?
    func noFireballs() -> Bool {
        guard let fetched = fetchedResultsController?.fetchedObjects else {
            print("No fireballs? We haven't tried to fetch them yet.")
            return true
        }
        return fetched.count == 0
    }
    
    /// Returns; Fireball at specified row. Fireballs are sorted by date ascending:false
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DatetimeCell", for: indexPath) as! DatetimeCell
        if let fireball = fireball(at: indexPath) {
            cell.date = fireball.swiftDate
        }
        return cell
    }
}
