//
//  FireballDataManagerTests.swift
//  FireballTracker
//
//  Created by Sean Berry on 3/2/17.
//  Copyright © 2017 Sean Berry. All rights reserved.
//

import XCTest
import FireballTracker

class FireballDataManagerTests: XCTestCase {
    var dataManager: FireballDataManager!
    
    override func setUp() {
        super.setUp()
        
        dataManager = FireballDataManager(inMemory: true)
        let loadStoreExpectation = expectation(description: "Load Core Data store")
        dataManager.loadStore(completion: {(description, error) in
            guard error == nil else {
                print("Failed to load data store: \(error!.localizedDescription)")
                return
            }
            loadStoreExpectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: { error in
            XCTAssertNil(error, "Error")
        })
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        dataManager = nil
    }
    
    func test_thatDataManager_savesOne() {
        // GIVEN: a fireball JSON
        let fireball = FireballJSON(date: Date(), latitude: 1, longitude: -1)
        
        // WHEN: it's saved to the data manager
        dataManager.save(jsonFireballs: [fireball])
        
        // THEN: dataManager returns 1 result
        let fireballCount = dataManager.allExistingFireballs().count
        XCTAssertEqual(fireballCount, 1)
    }
    
}
