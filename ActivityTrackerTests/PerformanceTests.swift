//
//  PerformanceTests.swift
//  ActivityTrackerTests
//
//  Created by Djallil Elkebir on 2021-07-20.
//

import XCTest
@testable import ActivityTracker

class PerformanceTests: BaseTestCase {
    func testAwardCalculationPerformance() throws {
        // Create significante number of test data
        for _ in 1...100 {
            try dataController.createSampleData()
        }
// simulate a lot of awards to test
        let awards = Array(repeating: Award.allAwards, count: 25).joined()
        XCTAssertEqual(awards.count, 500, "This checks the awards count is constant. Change this if you add awards.")

        measure {
            _ = awards.filter(dataController.hasEarned).count
        }
        
    }
}
