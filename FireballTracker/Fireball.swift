//
//  Fireball.swift
//  FireballTracker
//
//  Created by Sean Berry on 2/28/17.
//  Copyright © 2017 Sean Berry. All rights reserved.
//

import Foundation
import CoreLocation

struct Fireball {
    let date: Date // GMT
    var coordinate: CLLocationCoordinate2D
    
    init(date: Date, latitude: Double, longitude: Double) {
        self.date = date
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
