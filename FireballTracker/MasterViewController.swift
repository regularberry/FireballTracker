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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fireballApi.getFireballs(completion: {(fireballs, error) in
            guard error == nil else {
                print("Failed to get fireballs: \(error!)")
                return
            }
            
            print("Received fireballs: \(fireballs)")
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            /*if let indexPath = self.tableView.indexPathForSelectedRow {
                
            }*/
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }

}

