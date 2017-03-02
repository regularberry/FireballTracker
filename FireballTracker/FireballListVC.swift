//
//  FireballListVC.swift
//  FireballTracker
//
//  Created by Sean Berry on 2/28/17.
//  Copyright © 2017 Sean Berry. All rights reserved.
//

import UIKit
import CoreData

class FireballListVC: UITableViewController, NSFetchedResultsControllerDelegate {
    
    lazy var dataManager: FireballDataManager = FireballDataManager()
    var fetchedResultsController: NSFetchedResultsController<FireballMO>!
    
    let fireballApi = FireballApi()
    var fireballs: [FireballMO] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        dataManager.loadStore(completion: {(description, error) in
            self.setupFetchedResultsController()
        })
        
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(FireballListVC.refreshData), for: .valueChanged)
    }
    
    func noFireballs() -> Bool {
        guard let fetched = fetchedResultsController.fetchedObjects else {
            print("No fireballs? We haven't tried to fetch them yet.")
            return false
        }
        return fetched.count == 0
    }
    
    func setupFetchedResultsController() {
        let fetch = NSFetchRequest<FireballMO>(entityName: "Fireball")
        fetch.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: dataManager.container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        self.fetchedResultsController.delegate = self
        
        do {
            try self.fetchedResultsController.performFetch()
            if noFireballs() {
                refreshData()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func refreshData() {
        fireballApi.getLatestFireballs(completion: { (jsonFireballs, error) in
            self.refreshControl?.endRefreshing()
            
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard jsonFireballs.count > 0 else {
                return
            }
            
            self.dataManager.replaceAllFireballs(with: jsonFireballs)
        })
    }
    
    func getOlderData() {
        guard let oldestDate = getOldestDate() else {
            return
        }
        
        fireballApi.getFireballs(afterDate: oldestDate, completion: { (jsonFireballs, error) in
            self.refreshControl?.endRefreshing()
            
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
        if let last = fireballs.last {
            return last.swiftDate
        }
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let detail = segue.destination as? FireballLocationVC else {
                return
            }
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let fireball = fetchedResultsController.object(at: indexPath)
                detail.fireball = fireball
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController.sections else {
            return 1
        }
        return sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows(inSection: section)
    }
    
    func numberOfRows(inSection: Int) -> Int {
        guard let sections = self.fetchedResultsController.sections else {
            return 0
        }
        
        guard inSection < sections.count else {
            return 0
        }
        
        return sections[inSection].numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let fireball = fetchedResultsController.object(at: indexPath)
        cell.textLabel!.text = fireball.dateStr
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == numberOfRows(inSection: 0) - 1 {
            getOlderData()
        }
    }
    
    // MARK: - FetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .update:
            self.tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            self.tableView.moveRow(at: indexPath!, to: newIndexPath!)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .fade)
        }
    }

}
