//
//  DataController.swift
//  ActivityTracker
//
//  Created by Djallil Elkebir on 2021-07-19.
//

import CoreData
import SwiftUI

class DataController: ObservableObject {
    let container: NSPersistentCloudKitContainer
    
    init(inMemory: Bool = false){
        container = NSPersistentCloudKitContainer(name: "Main", managedObjectModel: Self.model)
        
        // For testing and previewing purposes, we create a
        // temporary, in-memory database by writing to /dev/null
        // so our data is destroyed after the app finishes running.
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Fatal Error loading store \(error.localizedDescription)")
            }
        }
    }
    
    static var preview: DataController =  {
        let dataController = DataController(inMemory: true)
        
        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Fatal Error creating the preview \(error.localizedDescription)")
        }
        return dataController
    }()
    func createSampleData() throws {
        let viewContext = container.viewContext
        for i in 1...5 {
            let project = Project(context: viewContext)
            project.title = "Project \(i)"
            project.items = []
            project.creationDate = Date()
            project.closed = Bool.random()
            
            for k in 1...10 {
                let item = Item(context: viewContext)
                item.title = "Item \(k)"
                item.creationDate = Date()
                item.completed = Bool.random()
                item.project = project
                item.priority = Int16.random(in: 1...3)
            }
        }
        try viewContext.save()
    }
    func save(){
        if container.viewContext.hasChanges{
            try? container.viewContext.save()
        }
    }
    
    func delete(_ object: NSManagedObject){
        container.viewContext.delete(object)
    }
    
    func deleteAll(){
        let itemFetchRequest:NSFetchRequest<NSFetchRequestResult> = Item.fetchRequest()
        let itemBatchDeleteRequest: NSBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: itemFetchRequest)
        _ = try? container.viewContext.execute(itemBatchDeleteRequest)
        
        let projectFetchRequest:NSFetchRequest<NSFetchRequestResult> = Project.fetchRequest()
        let projectBatchDeleteRequest: NSBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: projectFetchRequest)
        _ = try? container.viewContext.execute(projectBatchDeleteRequest)
    }
    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }
    
    func hasEarned(award: Award) -> Bool {
        switch award.criterion {
        case "items":
            let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
        // returns true if they added a certain number of items
            
        
        case "complete":
            let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
            fetchRequest.predicate = NSPredicate(format: "completed = true")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
        // returns true if they completed a certain number of items
        default:
            // fatalError("Unknown award criterion \(award.criterion).")
            return false
        // an unknown award criterion; this should never be allowed
        }
    }
    static let model: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "Main", withExtension: "momd") else {
            fatalError("Failed to locate model file.")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to load model file.")
        }

        return managedObjectModel
    }()
}
