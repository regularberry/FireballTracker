//
//  Datetime.swift
//  FireballTracker
//
//  Created by Sean Berry on 3/3/17.
//  Copyright © 2017 Sean Berry. All rights reserved.
//

import Foundation
import UIKit

/// Displays a datetime in a tableview cell
class DatetimeCell: UITableViewCell {
    @IBOutlet weak var longDateLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    
    var date: Date? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let date = date {
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            
            formatter.dateFormat = "HH"
            hourLabel.text = formatter.string(from: date)
            
            formatter.dateFormat = "mm"
            minuteLabel.text = formatter.string(from: date)
            
            formatter.dateFormat = "EEEE   dd - MM - yy"
            longDateLabel.text = formatter.string(from: date)
        } else {
            hourLabel.text = ""
            minuteLabel.text = ""
            longDateLabel.text = ""
        }
    }
    
    override func awakeFromNib() {
        updateView()        
    }
}
