//
//  FireballApiClient.swift
//  FireballTracker
//
//  Created by Sean Berry on 2/28/17.
//  Copyright © 2017 Sean Berry. All rights reserved.
//

import Foundation

struct FireballApiClient {
    
    typealias FireballCompletion = ([FireballJSON], Error?) -> ()
    
    let chunkSize: Int
    let baseUrlStr: String
    let parser: ParsesFireballs
    
    init(parser: ParsesFireballs = FireballParser(), chunkSize: Int = 40) {
        self.parser = parser
        self.chunkSize = chunkSize
        self.baseUrlStr = "https://ssd-api.jpl.nasa.gov/fireball.api?req-loc=true&limit=\(chunkSize)"
    }
    
    func getFireballs(beforeDate: Date, completion: @escaping FireballCompletion) {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let dateStr = formatter.string(from: beforeDate)
        let split = dateStr.components(separatedBy: " ")
        let dateUrlField = "\(split[0])T\(split[1])"
        let url = URL(string: "\(baseUrlStr)&date-max=\(dateUrlField)")!
        getFireballs(url: url, completion: completion)
    }
    
    func getLatestFireballs(completion: @escaping FireballCompletion) {
        getFireballs(url: URL(string: baseUrlStr)!, completion: completion)
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
                completion(self.parser.fireballs(fromJson: json), nil)
            } catch let error {
                completion([], error)
            }
        })
        task.resume()
    }
}
