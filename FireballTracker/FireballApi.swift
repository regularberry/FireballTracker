//
//  FireballApi.swift
//  FireballTracker
//
//  Created by Sean Berry on 2/28/17.
//  Copyright © 2017 Sean Berry. All rights reserved.
//

import Foundation

struct FireballApi {
    
    public typealias FireballCompletion = ([Fireball], Error?) -> ()
    let url = URL(string: "https://ssd-api.jpl.nasa.gov/fireball.api?req-loc=true&limit=3")!
    
    func getFireballs(completion: @escaping FireballCompletion) {
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: {
            (data:Data?, response:URLResponse?, error:Error?) -> Void in
            
            if let error = error {
                completion([], error)
                return
            }
            
            do {
                var fireballs = [Fireball]()
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as! [String : Any]
                let fields = jsonResult["fields"] as! [String]
                if let rawFireballs = jsonResult["data"] as? [[Any]] {
                    
                    for fireballData in rawFireballs {
                        if fields.count == fireballData.count {
                            var fireballDict = [String: Any]()
                            for (index, val) in fields.enumerated() {
                                fireballDict[val] = fireballData[index]
                            }
                            let fireball = try Fireball(json: fireballDict)
                            fireballs.append(fireball)
                        }
                    }
                }
                completion(fireballs, nil)
            } catch let error {
                completion([], error)
            }
        })
        task.resume()
    }
    
}
