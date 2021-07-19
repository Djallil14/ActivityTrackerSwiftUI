//
//  Project+CoreDataHelpers.swift
//  ActivityTracker
//
//  Created by Djallil Elkebir on 2021-07-19.
//

import Foundation

extension Project {
    var projectTitle: String {
        title ?? "New Project"
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
    
    var projectItems: [Item] {
        
        let itemsArray = items?.allObjects as? [Item] ?? []
        return itemsArray.sorted{ first, second in
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
    
    static var exampleProject: Project {
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
