//
//  FireballApiClientTests.swift
//  FireballTracker
//
//  Created by Sean Berry on 3/3/17.
//  Copyright © 2017 Sean Berry. All rights reserved.
//

import XCTest
@testable import FireballTracker

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
        let client = ChunkApiClient()
        
        // WHEN: we ask the server for the latest fireballs
        let latestCompleted = expectation(description: "LatestFireballs")
        client.getLatestFireballs(completion: {(fireballs, error) in
            // THEN: completion gets called with no error
            if error == nil {
                latestCompleted.fulfill()
            }
        })
        
        waitForExpectations(timeout: 10, handler:nil)
    }
    
    func test_thatApiClient_completesBeforeDateCallWithoutError() {
        // GIVEN: an api client
        let client = ChunkApiClient()
        
        // WHEN: we ask the server for fireballs before now
        let beforeCompleted = expectation(description: "FireballAfterDate")
        client.getFireballs(beforeDate: Date(), completion: {(fireballs, error) in
            // THEN: completion gets called with no error
            if error == nil {
                beforeCompleted.fulfill()
            }
        })
        
        waitForExpectations(timeout: 10, handler:nil)
    }
    
    func test_thatApiClient_grabsFireballCountFromChunkSize() {
        // GIVEN: an api client, parser and chunk size
        let chunkSize = 10
        let client = ChunkApiClient(parser: FireballParser(), chunkSize: chunkSize)
        
        // WHEN: we ask the server for the latest fireballs
        let latestCompleted = expectation(description: "LatestFireballs")
        client.getFireballs(beforeDate: Date(), completion: {(fireballs, error) in
            guard error == nil else {
                return
            }
            // THEN: fireball count is the same as chunk size
            XCTAssert(fireballs.count == chunkSize)
            latestCompleted.fulfill()
        })
        
        
        waitForExpectations(timeout: 10, handler:nil)
    }
    
    func test_thatApiClient_grabsFireballCountFromChunkSizeBeforeDate() {
        // GIVEN: an api client, parser and chunk size and a date
        let chunkSize = 30
        let date = Date()
        let client = ChunkApiClient(parser: FireballParser(), chunkSize: chunkSize)
        
        // WHEN: we ask the server for the fireballs before date
        let beforeCompleted = expectation(description: "FireballsBefore")
        client.getFireballs(beforeDate: date, completion: {(fireballs, error) in
            guard error == nil else {
                return
            }
            // THEN: fireball count is the same as chunk size
            XCTAssert(fireballs.count == chunkSize)
            beforeCompleted.fulfill()
        })
        
        waitForExpectations(timeout: 10, handler:nil)
    }
    
    func test_thatApiClient_grabsNothingWhenDateTooOld() {
        // GIVEN: an api client, parser and chunk size and a date
        let chunkSize = 100
        let date = Date(timeIntervalSince1970: 0)
        let client = ChunkApiClient(parser: FireballParser(), chunkSize: chunkSize)
        
        // WHEN: we ask the server for the fireballs before date
        let beforeCompleted = expectation(description: "FireballsBefore")
        client.getFireballs(beforeDate: date, completion: {(fireballs, error) in
            guard error == nil else {
                return
            }
            // THEN: fireball count is 0
            XCTAssert(fireballs.count == 0)
            beforeCompleted.fulfill()
        })
        
        waitForExpectations(timeout: 10, handler:nil)
    }
}
