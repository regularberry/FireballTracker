//
//  FireballModelTests.swift
//  FireballTracker
//
//  Created by Sean Berry on 3/2/17.
//  Copyright © 2017 Sean Berry. All rights reserved.
//

import XCTest
@testable import FireballTracker

class FireballModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_thatFireballJSON_doesntMutateData() {
        // GIVEN: a date, longitude, latitude
        let date = Date(timeIntervalSinceNow: 0)
        let latitude: Double = 4
        let longitude: Double = -5
        
        // WHEN: a FireballJSON is created
        let fireballJSON = FireballJSON(date: date, latitude: latitude, longitude: longitude)
        
        // THEN: data is equal
        XCTAssertEqual(date, fireballJSON.date)
        XCTAssertEqual(latitude, fireballJSON.latitude)
        XCTAssertEqual(longitude, fireballJSON.longitude)
    }
    
}
