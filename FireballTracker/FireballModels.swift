//
//  Fireball.swift
//  FireballTracker
//
//  Created by Sean Berry on 2/28/17.
//  Copyright © 2017 Sean Berry. All rights reserved.
//

import Foundation
import CoreLocation

/// Fireball data converted from JSON
struct FireballJSON {
    let date: Date
    let latitude: Double
    let longitude: Double
    
    init(date: Date, latitude: Double, longitude: Double) {
        self.date = date
        self.latitude = latitude
        self.longitude = longitude
    }
}

/// Core Data class of the Fireball entity
extension FireballMO {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var swiftDate: Date {
        return date as! Date
    }
}
