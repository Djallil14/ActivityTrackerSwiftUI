//
//  AssetTest.swift
//  ActivityTrackerTests
//
//  Created by Djallil Elkebir on 2021-07-20.
//

import XCTest
@testable import ActivityTracker

class AssetTest: XCTestCase {
    
    func testColorsExist() {
        for color in Project.colors {
            XCTAssertNotNil(UIColor(named: color), "Failed to load color '\(color)' from asset catalog.")
        }
    }
    func testJSONLoadsCorrectly() {
        XCTAssertFalse(Award.allAwards.isEmpty, "Failed to load awards from JSON.")
    }
}
