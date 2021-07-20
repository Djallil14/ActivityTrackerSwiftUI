//
//  ActivityTrackerTests.swift
//  ActivityTrackerTests
//
//  Created by Djallil Elkebir on 2021-07-20.
//

import XCTest
import CoreData
@testable import ActivityTracker

class BaseTestCase: XCTestCase {

    var dataController: DataController!
    var managedObjectContext: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        managedObjectContext = dataController.container.viewContext
    }

}
