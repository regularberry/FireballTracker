//
//  FakeApiClient.swift
//  FireballTracker
//
//  Created by Sean Berry on 3/6/17.
//  Copyright © 2017 Sean Berry. All rights reserved.
//

import Foundation
@testable import FireballTracker

/// Fake client used for tests
struct FakeApiClient: FireballApiClient {
    
    func getFireballs(beforeDate: Date, completion: @escaping FireballCompletion) {
        let fireball = FireballJSON(date: beforeDate.addingTimeInterval(-1), latitude: 1, longitude: 1)
        completion([fireball], nil)
    }
    
    func getLatestFireballs(completion: @escaping FireballCompletion) {
        let fireball = FireballJSON(date: Date(), latitude: 1, longitude: 1)
        completion([fireball], nil)
    }
}
