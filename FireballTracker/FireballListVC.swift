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
    
    lazy var fireballDataSource: FireballListDataSource = FireballListDataSource(fetchedDelegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(FireballListVC.refreshData), for: .valueChanged)
        
        tableView.dataSource = fireballDataSource
        fireballDataSource.loadData(completionHandler: {(error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            if self.fireballDataSource.noFireballs() {
                self.refreshData()
            }
        })
    }
    
    func refreshData() {
        fireballDataSource.refreshData(completionHandler: { (error) in
            self.refreshControl?.endRefreshing()
            
            switch error {
            case is DataSourceError:
                
                switch (error as! DataSourceError) {
                case .completelyConsumed:
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
                
            case let error:
                print(error!.localizedDescription)
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let detail = segue.destination as? FireballLocationVC else {
                return
            }
            guard let indexPath = self.tableView.indexPathForSelectedRow else {
                return
            }
            guard let fireball = fireballDataSource.fireball(at: indexPath) else {
                return
            }
            
            detail.fireball = fireball
        }
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == fireballDataSource.numberOfRows() - 1 {
            if fireballDataSource.possiblyMoreData {
                fireballDataSource.getOlderData()
            }
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

