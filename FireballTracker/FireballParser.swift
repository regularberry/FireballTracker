//
//  FireballParser.swift
//  FireballTracker
//
//  Created by Sean Berry on 3/1/17.
//  Copyright © 2017 Sean Berry. All rights reserved.
//

import Foundation

/**
 - missing: If parameter wasn't found in JSON
 - parse: If parameter was found but failed to parse correctly
 */
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

/** 
 Translates JSON from NASA's Api to local FireballJSON structs
 https://ssd-api.jpl.nasa.gov/doc/fireball.html
 
 Configured for Api version 1.0
 */
struct FireballParser {
    
    /**
     parameter fromJson: JSON of full results - assumed to include field data
     */
    func fireballs(fromJson: [String: Any]) -> [FireballJSON] {

        var fireballs = [FireballJSON]()
        
        let fireballDicts = parseFireballDicts(json: fromJson)
        for dict in fireballDicts {
            do {
                let date = try parseDate(dict)
                let latitude = try parseLatitude(dict)
                let longitude = try parseLongitude(dict)
                fireballs.append(FireballJSON(date: date, latitude: latitude, longitude: longitude))
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        return fireballs
    }
    
    /// Creates Date from text - NASA Api has dates in GMT time zone
    func date(from dateStr: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.date(from: dateStr)
    }
    
    private func parseFireballDicts(json: [String: Any]) -> [[String: Any]] {
        guard let fields = json["fields"] as? [String] else {
            return []
        }
        
        guard let rawFireballs = json["data"] as? [[Any]] else {
            return []
        }
        
        // links up provided fields to array of fireball data
        var fireballDicts = [[String: Any]]()
        for rawFireball in rawFireballs {
            if fields.count == rawFireball.count {
                var dict = [String: Any]()
                for (index, val) in fields.enumerated() {
                    dict[val] = rawFireball[index]
                }
                fireballDicts.append(dict)
            }
        }
        
        return fireballDicts
    }
    
    private func parseDate(_ dict: [String: Any]) throws -> Date {
        guard let dateStr = dict["date"] as? String else {
            throw JSONError.missing("Date")
        }
        
        guard let date = date(from: dateStr) else {
            throw JSONError.parse("Date")
        }
        return date
    }
    
    private func parseLatitude(_ dict: [String: Any]) throws -> Double {
        guard let latitudeStr = dict["lat"] as? String else {
            throw JSONError.missing("Latitude")
        }
        
        guard var latitude = Double(latitudeStr) else {
            throw JSONError.parse("Latitude")
        }
        
        guard let latDirStr = dict["lat-dir"] as? String else {
            throw JSONError.missing("Latitude Direction")
        }
        
        guard let latDir = LatitudeDirection(rawValue: latDirStr) else {
            throw JSONError.parse("Latitude Direction")
        }
        
        if latDir == .south {
            latitude *= -1
        }
        return latitude
    }
    
    private func parseLongitude(_ dict: [String: Any]) throws -> Double {
        guard let longitudeStr = dict["lon"] as? String else {
            throw JSONError.missing("Longitude")
        }
        
        guard var longitude = Double(longitudeStr) else {
            throw JSONError.parse("Longitude")
        }
        
        guard let lonDirStr = dict["lon-dir"] as? String else {
            throw JSONError.missing("Longitude Direction")
        }
        
        guard let lonDir = LongitudeDirection(rawValue: lonDirStr) else {
            throw JSONError.parse("Longitude Direction")
        }
        
        if lonDir == .west {
            longitude *= -1
        }
        
        return longitude
    }
}
