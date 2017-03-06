//
//  FireballListVC.swift
//  FireballTracker
//
//  Created by Sean Berry on 2/28/17.
//  Copyright © 2017 Sean Berry. All rights reserved.
//

import UIKit
import CoreData

/// Displays a table of fireballs, segues to FireballLocationVC
class FireballListVC: UITableViewController, NSFetchedResultsControllerDelegate {
    
    lazy var fireballDataSource: FireballListDataSource = FireballListDataSource(fetchedDelegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(FireballListVC.getFreshData), for: .valueChanged)
        
        tableView.dataSource = fireballDataSource
        fireballDataSource.loadData(completionHandler: {(error) in
            guard error == nil else {
                self.processDataError(error: error!)
                return
            }
            if self.fireballDataSource.noFireballs() {
                self.getFreshData()
            }
        })
    }
    
    /// Used at top of table view when they pull to refresh
    func getFreshData() {
        fireballDataSource.getFreshData(completionHandler: { (error) in
            self.refreshControl?.endRefreshing()
            self.processDataError(error: error)
        })
    }
    
    /// Used at bottom of table view when they're scrolling all the way down
    func getOlderData() {
        guard fireballDataSource.possiblyMoreData else {
            return
        }
        
        fireballDataSource.getOlderData(completionHandler: { (error) in
            self.processDataError(error: error)
        })
    }
    
    private func processDataError(error: Error?) {
        guard let error = error else {
            return
        }
        
        switch error {
        case DataSourceError.completelyConsumed:
            hideBottomActivityCell()
        case let error:
            displayErrorToUser(error: error)
        }
    }
    
    private func displayErrorToUser(error: Error) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Data Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: false, completion: nil)
        }
    }
    
    private func hideBottomActivityCell() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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

    /// Enables infinite scrolling
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {        
        // Auto-retrieve more data when user gets to the bottom of the table view
        if indexPath.row == fireballDataSource.numberOfRows() - 1 {
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

