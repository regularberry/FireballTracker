//
//  Fireball.swift
//  FireballTracker
//
//  Created by Sean Berry on 2/28/17.
//  Copyright © 2017 Sean Berry. All rights reserved.
//

import Foundation
import CoreLocation

enum JSONError: Error {
    case missing(String)
    case parse(String)
}

enum LatitudeDirection: String {
    case north = "N"
    case south = "S"
}

enum LongitudeDirection: String {
    case east = "E"
    case west = "W"
}

struct Fireball {
    let date: Date // GMT
    var coordinate: CLLocationCoordinate2D
    
    init(json: [String:Any]) throws {        
        guard let dateStr = json["date"] as? String else {
            throw JSONError.missing("Date")
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        guard let date = dateFormatter.date(from: dateStr) else {
            throw JSONError.parse("Date")
        }
        
        guard let latitudeStr = json["lat"] as? String else {
            throw JSONError.missing("Latitude")
        }
        
        guard var latitude = Double(latitudeStr) else {
            throw JSONError.parse("Latitude")
        }
        
        guard let latDirStr = json["lat-dir"] as? String else {
            throw JSONError.missing("Latitude Direction")
        }
        
        guard let latDir = LatitudeDirection(rawValue: latDirStr) else {
            throw JSONError.parse("Latitude Direction")
        }
        
        guard let longitudeStr = json["lon"] as? String else {
            throw JSONError.missing("Longitude")
        }
        
        guard var longitude = Double(longitudeStr) else {
            throw JSONError.parse("Longitude")
        }
        
        guard let lonDirStr = json["lon-dir"] as? String else {
            throw JSONError.missing("Longitude Direction")
        }
        
        guard let lonDir = LongitudeDirection(rawValue: lonDirStr) else {
            throw JSONError.parse("Longitude Direction")
        }
        
        if latDir == .south {
            latitude *= -1
        }
        
        if lonDir == .west {
            longitude *= -1
        }
        
        self.date = date
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
}
