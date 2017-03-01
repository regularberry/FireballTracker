//
//  FireballApi.swift
//  FireballTracker
//
//  Created by Sean Berry on 2/28/17.
//  Copyright © 2017 Sean Berry. All rights reserved.
//

import Foundation

struct FireballApi {
    
    public typealias FireballCompletion = ([FireballJSON], Error?) -> ()
    let url = URL(string: "https://ssd-api.jpl.nasa.gov/fireball.api?req-loc=true&limit=10")!
    
    func getFireballs(completion: @escaping FireballCompletion) {
        
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
