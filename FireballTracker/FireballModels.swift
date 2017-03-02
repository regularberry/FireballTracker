//
//  Fireball.swift
//  FireballTracker
//
//  Created by Sean Berry on 2/28/17.
//  Copyright © 2017 Sean Berry. All rights reserved.
//

import Foundation
import CoreLocation

public struct FireballJSON {
    public let date: Date
    public let latitude: Double
    public let longitude: Double
    
    public init(date: Date, latitude: Double, longitude: Double) {
        self.date = date
        self.latitude = latitude
        self.longitude = longitude
    }
}

extension FireballMO {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var swiftDate: Date {
        return date as! Date
    }
    
    var dateStr: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/YYYY"
        return formatter.string(from: date as! Date)
    }
}
