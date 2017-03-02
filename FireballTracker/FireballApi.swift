//
//  FireballApi.swift
//  FireballTracker
//
//  Created by Sean Berry on 2/28/17.
//  Copyright © 2017 Sean Berry. All rights reserved.
//

import Foundation

typealias FireballCompletion = ([FireballJSON], Error?) -> ()
let RESULTS_CHUNK_SIZE = 40
let BASE_URL_STR = "https://ssd-api.jpl.nasa.gov/fireball.api?req-loc=true&limit=\(RESULTS_CHUNK_SIZE)"

struct FireballApi {
    
    func getFireballs(afterDate: Date, completion: @escaping FireballCompletion) {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let dateStr = formatter.string(from: afterDate)
        let split = dateStr.components(separatedBy: " ")
        let dateUrlField = "\(split[0])T\(split[1])"
        let url = URL(string: "\(BASE_URL_STR)&date-max=\(dateUrlField)")!
        getFireballs(url: url, completion: completion)
    }
    
    func getLatestFireballs(completion: @escaping FireballCompletion) {
        getFireballs(url: URL(string: BASE_URL_STR)!, completion: completion)
    }
    
    private func getFireballs(url: URL, completion: @escaping FireballCompletion) {
        let task = URLSession.shared.dataTask(with: url, completionHandler: {
            (data:Data?, response:URLResponse?, error:Error?) -> Void in
            
            if let error = error {
                completion([], error)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String : Any]
                let parser = FireballParser(json: json)
                completion(parser.fireballs(), nil)
            } catch let error {
                completion([], error)
            }
        })
        task.resume()
    }
    
}
