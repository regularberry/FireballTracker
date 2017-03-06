//
//  FireballApiClient.swift
//  FireballTracker
//
//  Created by Sean Berry on 2/28/17.
//  Copyright © 2017 Sean Berry. All rights reserved.
//

import Foundation

typealias FireballCompletion = ([FireballJSON], Error?) -> Void

/**
 Grabs data from NASA's fireball API which is documented here: https://ssd-api.jpl.nasa.gov/doc/fireball.html
 */
protocol FireballApiClient {
    func getFireballs(beforeDate: Date, completion: @escaping FireballCompletion)
    func getLatestFireballs(completion: @escaping FireballCompletion)
}

/// Implementation of FireballApiClient that lets you specify how many fireballs to get at a time
struct ChunkApiClient: FireballApiClient {
    
    let chunkSize: Int
    let baseUrlStr: String
    let parser: FireballParser
    
    /**
     parameter parser: Defaults to FireballParser(), used to parse results from network call
     parameter chunkSize: # of results to grab from api on each call
     */
    init(parser: FireballParser = FireballParser(), chunkSize: Int = 40) {
        self.parser = parser
        self.chunkSize = chunkSize
        self.baseUrlStr = "https://ssd-api.jpl.nasa.gov/fireball.api?req-loc=true&limit=\(chunkSize)"
    }
    
    /**
     Grabs # of fireballs that happened before the given date.
     
     parameter beforeDate: returns earlier fireballs, NOT including this exact datetime. Yes it looks at the time as well.
     parameter completion: If any fireballs found, return as FireballJSON array, otherwise return the error.
     */
    func getFireballs(beforeDate: Date, completion: @escaping FireballCompletion) {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss"
        let dateStr = formatter.string(from: beforeDate)
        let url = URL(string: "\(baseUrlStr)&date-max=\(dateStr)")!
        getFireballs(url: url, completion: completion)
    }
    
    /**
     Grabs # newest fireballs from api
     
     parameter completion: If any fireballs found, return as FireballJSON array, otherwise return the error.
     */
    func getLatestFireballs(completion: @escaping FireballCompletion) {
        getFireballs(url: URL(string: baseUrlStr)!, completion: completion)
    }
    
    private func getFireballs(url: URL, completion: @escaping FireballCompletion) {
        let task = URLSession.shared.dataTask(with: url, completionHandler: {
            (data: Data?, _, error: Error?) -> Void in
            
            if let error = error {
                completion([], error)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any] ?? [:]
                completion(self.parser.fireballs(fromJson: json), nil)
            } catch let error {
                completion([], error)
            }
        })
        task.resume()
    }
}
