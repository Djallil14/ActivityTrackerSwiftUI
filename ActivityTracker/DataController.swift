//
//  DataController.swift
//  ActivityTracker
//
//  Created by Djallil Elkebir on 2021-07-19.
//

import CoreData
import SwiftUI

class DataController: ObservableObject {
    let container : NSPersistentCloudKitContainer
    
    init(inMemory: Bool = false){
        container = NSPersistentCloudKitContainer(name: "Main")
        
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
                item.creationData = Date()
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
        let itemBatchDeleteRequest : NSBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: itemFetchRequest)
        _ = try? container.viewContext.execute(itemBatchDeleteRequest)
        
        let projectFetchRequest:NSFetchRequest<NSFetchRequestResult> = Project.fetchRequest()
        let projectBatchDeleteRequest : NSBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: projectFetchRequest)
        _ = try? container.viewContext.execute(projectBatchDeleteRequest)
    }
}
