//
//  Project+CoreDataHelpers.swift
//  ActivityTracker
//
//  Created by Djallil Elkebir on 2021-07-19.
//

import Foundation
import SwiftUI

extension Project {
    var projectTitle: String {
        title ?? NSLocalizedString("New Project", comment: "Create new project")
    }
    var projectDetail: String {
        detail ?? ""
    }
    var projectColor: String {
        color ?? "Light Blue"
    }
    var projectCreationDate: Date {
        creationDate ?? Date()
    }
    
    static let colors = ["Pink", "Purple", "Red", "Orange", "Gold", "Green", "Teal", "Light Blue", "Dark Blue", "Midnight", "Dark Gray", "Gray"]
    
    var projectItems: [Item] {
        items?.allObjects as? [Item] ?? []
    }
    
    var label: LocalizedStringKey {
        LocalizedStringKey("\(projectTitle), \(projectItems.count) items, \(completionAmount * 100, specifier: "%g")% complete.")
    }
    
    var projectItemsDefaultSorted: [Item] {
        projectItems.sorted{ first, second in
            if !first.completed {
                if second.completed{
                    return true
                }
            } else if first.completed {
                if !second.completed{
                    return false
                }
            }
            if first.priority > second.priority {
                return true
            } else if first.priority < second.priority{
                return false
            }
            return first.itemCreationDate < second.itemCreationDate
        }
    }
    
    var completionAmount: Double {
        let originalItems = items?.allObjects as? [Item] ?? []
        guard originalItems.isEmpty == false else {
            return 0
        }
        let completedItems = originalItems.filter(\.completed)
        return Double(completedItems.count) / Double(originalItems.count)
    }
    
    static var example: Project {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let project = Project(context: viewContext)
        project.title = "Example Project"
        project.detail = "description of the project example"
        project.closed = true
        project.creationDate = Date()
        return project
    }
    
    
}
