//
//  FireballParserTests.swift
//  FireballTracker
//
//  Created by Sean Berry on 3/3/17.
//  Copyright © 2017 Sean Berry. All rights reserved.
//

import XCTest
import FireballTracker

class FireballParserTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func load(jsonFilename: String) -> [String: Any] {
        guard let file = Bundle(for: type(of: self)).url(forResource: jsonFilename, withExtension: "json") else {
            XCTAssert(false, "Couldn't load JSON file: \(jsonFilename)")
            return [:]
        }
        do {
            let data = try Data(contentsOf: file)
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            guard let dict = json as? [String: Any] else {
                XCTAssert(false, "JSON data from file:\(jsonFilename) not recognized as JSON")
                return [:]
            }
            return dict
        } catch {
            XCTAssert(false, error.localizedDescription)
        }
        return [:]
    }
    
    func test_thatParser_parsesSingleResult() {
        // GIVEN: a parser and a json file with 1 result and premade data
        let parser = FireballParser()
        let json = load(jsonFilename: "Single")
        let lat = 29.5
        let lon = 13.5
        
        // WHEN: a parser processes the single result
        let fireballs = parser.fireballs(fromJson: json)
        let date = parser.date(from: "2017-02-25 01:22:59")
        
        // THEN: result count is 1
        XCTAssert(fireballs.count == 1)
        
        // THEN: date was constructed from string
        XCTAssert(date != nil)
        
        guard fireballs.count > 0 else {
            return
        }
        let fireball = fireballs[0]
        // THEN: result is accurate to file
        XCTAssert(fireball.date == date!, "Premade Date:\(date) does not equal Fireball Date:\(fireball.date)")
        XCTAssert(fireball.latitude == lat)
        XCTAssert(fireball.longitude == lon)
    }
    
    func test_thatParser_parsesDirectionsIntoNegatives() {
        // GIVEN: a parser and a json file with 1 result and premade data
        let parser = FireballParser()
        let json = load(jsonFilename: "SingleNegative")
        let lat: Double = -29
        let lon: Double = -13
        
        // WHEN: a parser processes the single result
        let fireballs = parser.fireballs(fromJson: json)
        
        // THEN: result count is 1
        XCTAssert(fireballs.count == 1)
        
        guard fireballs.count > 0 else {
            return
        }
        let fireball = fireballs[0]
        // THEN: result interprets lat/lon directions into appropriate negatives
        XCTAssert(fireball.latitude == lat)
        XCTAssert(fireball.longitude == lon)
    }
    
    func test_thatParser_parsesTwentyResults() {
        // GIVEN: a parser and a json file with 20 results
        let parser = FireballParser()
        let json = load(jsonFilename: "Twenty")
        
        // WHEN: a parser processes the json
        let fireballs = parser.fireballs(fromJson: json)
        
        // THEN: result count is 20
        XCTAssert(fireballs.count == 20)
    }
    
    func test_thatParser_parsesGarbageIntoZeroResults() {
        // GIVEN: a parser and garbage
        let parser = FireballParser()
        let garbage = ["THIS IS NONSENSE DATA": 55555]
        
        // WHEN: a parser processes the json
        let fireballs = parser.fireballs(fromJson: garbage)
        
        // THEN: result count is 0
        XCTAssert(fireballs.count == 0)
    }
    
    func test_thatParser_parsesNothingIntoNothing() {
        // GIVEN: a parser
        let parser = FireballParser()
        
        // WHEN: a parser is given an empty dict
        let fireballs = parser.fireballs(fromJson: [:])
        
        // THEN: result count is 0
        XCTAssert(fireballs.count == 0)
    }
    
}
