//
//  DayCell.swift
//  FireballTracker
//
//  Created by Sean Berry on 3/3/17.
//  Copyright © 2017 Sean Berry. All rights reserved.
//

import Foundation
import UIKit

class DayCell: UITableViewCell {
    @IBOutlet weak var longDateLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    
    @IBOutlet weak var rightContainerView: UIView!
    @IBOutlet weak var leftContainerView: UIView!
    @IBOutlet weak var bottomContainerView: UIView!
    
    var fireball: FireballMO? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let fireball = fireball {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute, .weekday, .month, .year], from: fireball.swiftDate)
            hourLabel.text = "\(components.hour!)"
            minuteLabel.text = "\(components.minute!)"
            
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "EEEE  MM - yy"
            
            longDateLabel.text = formatter.string(from: fireball.swiftDate)
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
