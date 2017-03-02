//
//  FireballApi.swift
//  FireballTracker
//
//  Created by Sean Berry on 2/28/17.
//  Copyright © 2017 Sean Berry. All rights reserved.
//

import Foundation

public struct FireballApi {
    
    public typealias FireballCompletion = ([FireballJSON], Error?) -> ()
    
    let chunkSize: Int
    let baseUrlStr: String
    
    public init(chunkSize: Int = 40) {
        self.chunkSize = chunkSize
        self.baseUrlStr = "https://ssd-api.jpl.nasa.gov/fireball.api?req-loc=true&limit=\(chunkSize)"
    }
    
    public func getFireballs(afterDate: Date, completion: @escaping FireballCompletion) {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let dateStr = formatter.string(from: afterDate)
        let split = dateStr.components(separatedBy: " ")
        let dateUrlField = "\(split[0])T\(split[1])"
        let url = URL(string: "\(baseUrlStr)&date-max=\(dateUrlField)")!
        getFireballs(url: url, completion: completion)
    }
    
    public func getLatestFireballs(completion: @escaping FireballCompletion) {
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
                let parser = FireballParser(json: json)
                completion(parser.fireballs(), nil)
            } catch let error {
                completion([], error)
            }
        })
        task.resume()
    }
}
