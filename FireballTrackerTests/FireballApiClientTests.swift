//
//  FireballApiClientTests.swift
//  FireballTracker
//
//  Created by Sean Berry on 3/3/17.
//  Copyright © 2017 Sean Berry. All rights reserved.
//

import XCTest
import FireballTracker

class FireballApiClientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_thatApiClient_completesLatestCallWithoutError() {
        // GIVEN: an api client
        let client = FireballApiClient()
        
        // WHEN: we ask the server for the latest fireballs
        let latestCompleted = expectation(description: "LatestFireballs")
        client.getLatestFireballs(completion: {(fireballs, error) in
            if error == nil {
                latestCompleted.fulfill()
            }
        })
        
        // THEN: completion gets called with no error
        waitForExpectations(timeout: 10, handler:nil)
    }
    
    func test_thatApiClient_completesBeforeDateCallWithoutError() {
        // GIVEN: an api client
        let client = FireballApiClient()
        
        // WHEN: we ask the server for fireballs before now
        let beforeCompleted = expectation(description: "FireballAfterDate")
        client.getFireballs(beforeDate: Date(), completion: {(fireballs, error) in
            if error == nil {
                beforeCompleted.fulfill()
            }
        })
        
        // THEN: completion gets called with no error
        waitForExpectations(timeout: 10, handler:nil)
    }
}
