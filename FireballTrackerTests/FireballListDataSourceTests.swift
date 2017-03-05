//
//  FireballListDataSourceTests.swift
//  FireballTracker
//
//  Created by Sean Berry on 3/5/17.
//  Copyright © 2017 Sean Berry. All rights reserved.
//

import XCTest
@testable import FireballTracker

class FireballListDataSourceTests: XCTestCase {
    var dataSource: FireballListDataSource!
    
    override func setUp() {
        super.setUp()
        let stack = FireballDataStack(inMemory: true)
        let client = FireballApiClient(chunkSize: 1)
        dataSource = FireballListDataSource(dataStack: stack, apiClient: client)
        
        let loadExpectation = expectation(description: "Load Data")
        dataSource.loadData(completionHandler: {(error) in
            if error == nil {
                loadExpectation.fulfill()
            }
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    override func tearDown() {
        super.tearDown()
        dataSource = nil
    }
    
    func test_thatDataSource_loadsFreshData() {
        // GIVEN: a data source with a chunk size of 1, and a fake table view
        // dataSource
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        // WHEN: it loads fresh data
        let freshExpect = expectation(description: "Load Fresh Data")
        dataSource.getFreshData(completionHandler: {(error) in
            if error == nil {
                freshExpect.fulfill()
            }
        })
        waitForExpectations(timeout: 10, handler: nil)
        dataSource.reloadData()
        
        // THEN: the data source returns 1 section and 1 row, and it hasn't exhausted all data
        XCTAssertEqual(dataSource.numberOfSections(in: tableView), 1)
        XCTAssertEqual(dataSource.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(dataSource.possiblyMoreData, true)
    }
    
    func test_thatDataSource_returnsOldestDate() {
        // GIVEN: a data source with a chunk size of 1
        // dataSource
        
        // WHEN: it doesn't do anything
        
        // THEN: the oldest date is nil
        XCTAssertNil(dataSource.getOldestDate())
        
        // WHEN: it loads fresh data
        let freshExpect = expectation(description: "Load Fresh Data")
        dataSource.getFreshData(completionHandler: {(error) in
            if error == nil {
                freshExpect.fulfill()
            }
        })
        waitForExpectations(timeout: 10, handler: nil)
        dataSource.reloadData()
        
        // THEN: it has an oldest date
        XCTAssertNotNil(dataSource.getOldestDate())
    }
    
    func test_thatDataSource_returnsFireball() {
        // GIVEN: a data source with a chunk size of 1
        // dataSource
        
        // WHEN: it loads fresh data
        let freshExpect = expectation(description: "Load Fresh Data")
        dataSource.getFreshData(completionHandler: {(error) in
            if error == nil {
                freshExpect.fulfill()
            }
        })
        waitForExpectations(timeout: 10, handler: nil)
        dataSource.reloadData()
        
        // THEN: it has a fireball
        XCTAssertNotNil(dataSource.fireball(at: IndexPath(row: 0, section: 0)))
    }
    
    func test_thatDataSource_loadsOlderData() {
        // GIVEN: a data source with a chunk size of 1
        // dataSource
        
        // WHEN: it loads fresh data
        let freshExpect = expectation(description: "Load Fresh Data")
        dataSource.getFreshData(completionHandler: {(error) in
            if error == nil {
                freshExpect.fulfill()
            }
        })
        waitForExpectations(timeout: 10, handler: nil)
        
        // THEN asking for data after the oldest date will return another result
        let oldExpect = expectation(description: "Load Older Data")
        dataSource.getOlderData(completionHandler: {(error) in
            if error == nil {
                oldExpect.fulfill()
            }
        })
        waitForExpectations(timeout: 10, handler: nil)
        dataSource.reloadData()
        XCTAssertEqual(dataSource.numberOfRows(), 2)
        
        // ONE MORE TIME
        let oldExpect2 = expectation(description: "Load Older Data")
        dataSource.getOlderData(completionHandler: {(error) in
            if error == nil {
                oldExpect2.fulfill()
            }
        })
        waitForExpectations(timeout: 10, handler: nil)
        dataSource.reloadData()
        XCTAssertEqual(dataSource.numberOfRows(), 3)
    }
    
    func test_thatDataSource_createsCells() {
        // GIVEN: a data source with a chunk size of 1 and a table view
        // dataSource
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let listVC = storyboard.instantiateViewController(withIdentifier: "ListVC") as! FireballListVC
        let tableView = listVC.tableView!
        
        // WHEN: it loads fresh data
        let freshExpect = expectation(description: "Load Fresh Data")
        dataSource.getFreshData(completionHandler: {(error) in
            if error == nil {
                freshExpect.fulfill()
            }
        })
        waitForExpectations(timeout: 10, handler: nil)
        
        // THEN: a cell will be available
        let indexPath = IndexPath(row: 0, section: 0)
        XCTAssertNotNil(dataSource.tableView(tableView, cellForRowAt: indexPath))
    }
    
    func test_thatDataSource_noFireballsWorks() {
        // GIVEN: a data source with a chunk size of 1
        // dataSource
        
        // WHEN: it doesn't load any data yet
        // THEN: noFireballs is true
        XCTAssertTrue(dataSource.noFireballs())
        
        // WHEN: it loads fresh data
        let freshExpect = expectation(description: "Load Fresh Data")
        dataSource.getFreshData(completionHandler: {(error) in
            if error == nil {
                freshExpect.fulfill()
            }
        })
        waitForExpectations(timeout: 10, handler: nil)
        dataSource.reloadData()
        
        // THEN: noFireballs is false
        XCTAssertFalse(dataSource.noFireballs())
    }
    
}
