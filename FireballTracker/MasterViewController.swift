//
//  MasterViewController.swift
//  FireballTracker
//
//  Created by Sean Berry on 2/28/17.
//  Copyright © 2017 Sean Berry. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController {
    
    let fireballApi = FireballApi()
    var fireballs: [Fireball] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fireballApi.getFireballs(completion: {(fireballs, error) in
            guard error == nil else {
                print("Failed to get fireballs: \(error!)")
                return
            }
            
            self.fireballs = fireballs
            self.tableView.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                if let fireball = fireball(at: indexPath) {
                    (segue.destination as! DetailViewController).fireball = fireball
                }
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fireballs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let fireball = fireball(at: indexPath) {
            cell.textLabel!.text = "\(fireball.date)"
        }
        return cell
    }
    
    func fireball(at indexPath: IndexPath) -> Fireball? {
        guard indexPath.row < fireballs.count else {
            return nil
        }
        return fireballs[indexPath.row]
    }

}

