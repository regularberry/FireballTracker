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
    
    func test_thatDataManager_saves() {
        // GIVEN: two fireball JSONs
        let fireballOne = FireballJSON(date: Date(), latitude: 1, longitude: -1)
        let fireballTwo = FireballJSON(date: Date(), latitude: 2, longitude: -2)
        
        // WHEN: they're saved to the data manager
        dataManager.save(jsonFireballs: [fireballOne, fireballTwo])
        
        // THEN: dataManager returns 2 results
        let fireballCount = dataManager.allExistingFireballs().count
        XCTAssertEqual(fireballCount, 2)
    }
    
    func test_thatDataManager_doesntSaveDuplicates() {
        // GIVEN: two identical fireballJSONs
        let date = Date()
        let lat: Double = 5
        let lon: Double = -4
        let fireballOne = FireballJSON(date: date, latitude: lat, longitude: lon)
        let fireballTwo = FireballJSON(date: date, latitude: lat, longitude: lon)
        
        // WHEN: they're saved to the data manager
        dataManager.save(jsonFireballs: [fireballOne, fireballTwo])
        
        // THEN: dataManager returns 1 result
        let fireballCount = dataManager.allExistingFireballs().count
        XCTAssertEqual(fireballCount, 1)
    }
    
    func test_thatDataManager_accuratelySaves() {
        // GIVEN: a fireball JSON
        let date = Date(timeIntervalSince1970: 2000)
        let lat: Double = 1.5
        let lon: Double = -5.6
        let fireball = FireballJSON(date: date, latitude: lat, longitude: lon)
        
        // WHEN: it's saved to the data manager
        dataManager.save(jsonFireballs: [fireball])
        
        // THEN: dataManager returns the same data as went in
        let fireballMO = dataManager.allExistingFireballs()[0]
        XCTAssertEqual(fireballMO.swiftDate, date)
        XCTAssertEqual(fireballMO.latitude, lat)
        XCTAssertEqual(fireballMO.longitude, lon)
        XCTAssertEqual(fireballMO.coordinate.latitude, lat)
        XCTAssertEqual(fireballMO.coordinate.longitude, lon)
    }
    
    func test_thatDataManager_replaces() {
        // GIVEN: 10 fireballs and 4 fireballs
        var tenFireballs = [FireballJSON]()
        for i in 1...10 {
            tenFireballs.append(FireballJSON(date: Date(), latitude: Double(i), longitude: Double(i)))
        }
        var fourFireballs = [FireballJSON]()
        for i in 1...4 {
            fourFireballs.append(FireballJSON(date: Date(), latitude: Double(i), longitude: Double(i)))
        }
        
        // WHEN: saved 10 fireballs
        dataManager.save(jsonFireballs: tenFireballs)
        
        // THEN: total fireballs = 10
        XCTAssertEqual(dataManager.allExistingFireballs().count, 10)
        
        // WHEN: replaced 10 fireballs with 4
        dataManager.replaceAllFireballs(with: fourFireballs)
        
        // THEN: total fireballs = 4
        XCTAssertEqual(dataManager.allExistingFireballs().count, 4)
    }
    
}
