//
//  FireballListVCTests.swift
//  FireballTracker
//
//  Created by Sean Berry on 3/4/17.
//  Copyright © 2017 Sean Berry. All rights reserved.
//

import XCTest
@testable import FireballTracker

class FireballListVCTests: XCTestCase {
    var listVC: FireballListVC!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        listVC = storyboard.instantiateViewController(withIdentifier: "ListVC") as! FireballListVC
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        listVC = nil
    }
    
    func test_thatListVC_loadsView() {
        // GIVEN: a list VC
        
        // WHEN: it's told to load its view
        _ = listVC.view
        
        // THEN: it has a view
        XCTAssert(listVC.view != nil)
    }
    
}
