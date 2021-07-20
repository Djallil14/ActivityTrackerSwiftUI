//
//  items+CoreDataHelpers.swift
//  ActivityTracker
//
//  Created by Djallil Elkebir on 2021-07-19.
//

import Foundation

extension Item {
    var itemTitle: String {
        title ?? "New Item"
    }
    var itemDetail: String {
        detail ?? ""
    }
    var itemCreationDate: Date {
        creationDate ?? Date()
    }
    
    static var example: Item {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let item = Item(context: viewContext)
        item.title = "Example Item"
        item.detail = "A description of an Item"
        item.creationDate = Date()
        item.priority = 3
        
        return item
    }
    enum SortOrder {
        case optimized, title, creationDate
    }
}
