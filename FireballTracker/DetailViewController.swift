//
//  DetailViewController.swift
//  FireballTracker
//
//  Created by Sean Berry on 2/28/17.
//  Copyright © 2017 Sean Berry. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    var fireball: Fireball?

    func configureView() {
        if let fireball = fireball {
            detailDescriptionLabel.text = "\(fireball.location)"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
}

