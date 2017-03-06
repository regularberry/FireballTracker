//
//  FireballLocationVCTests.swift
//  FireballTracker
//
//  Created by Sean Berry on 3/6/17.
//  Copyright © 2017 Sean Berry. All rights reserved.
//

import XCTest
@testable import FireballTracker

class FireballLocationVCTests: XCTestCase {
    var locationVC: FireballLocationVC!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        locationVC = storyboard.instantiateViewController(withIdentifier: "LocationVC") as! FireballLocationVC
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_thatLocationVC_loadsView() {
        // GIVEN: a locationVC
        // locationVC
        
        // WHEN: the view is called
        _ = locationVC.view
        
        // THEN: the view was loaded
        XCTAssertNotNil(locationVC.view)
    }
}
