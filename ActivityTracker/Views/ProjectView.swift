//
//  ProjectView.swift
//  ActivityTracker
//
//  Created by Djallil Elkebir on 2021-07-19.
//

import SwiftUI

struct ProjectView: View {
    static let openTag: String? = "Open"
    static let closedTag: String? = "Closed"
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    
    let showClosedProject: Bool
    let projects: FetchRequest<Project>
    
    init(showClosedProject: Bool){
        self.showClosedProject = showClosedProject
        projects = FetchRequest<Project>(entity: Project.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)
        ], predicate: NSPredicate(format: "closed = %d", showClosedProject))
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(projects.wrappedValue){ project in
                    Section(header: ProjectHeaderView(project: project)){
                        ForEach(project.projectItems){item in
                            ItemRowView(item: item)
                        }.onDelete{offsets in
                            let allItems = project.projectItems
                            for offset in offsets {
                                let item = allItems[offset]
                                dataController.delete(item)
                            }
                            dataController.save()
                        }
                        if showClosedProject == false {
                            Button(action: {
                                withAnimation{
                                    if showClosedProject == false {
                                        let item = Item(context: managedObjectContext)
                                        item.project = project
                                        item.creationDate = Date()
                                        dataController.save()
                                    }
                                }
                            }){
                                Label("Add New Item", systemImage: "plus")
                            }
                        }
                    }
                }
            }.listStyle(InsetGroupedListStyle())
            .navigationTitle(showClosedProject ? "Closed Projects" : "Open Projects")
            .toolbar{
                Button(action: {
                    withAnimation{
                        if showClosedProject == false {
                            let project = Project(context: managedObjectContext)
                            project.closed = false
                            project.creationDate = Date()
                            dataController.save()
                        }
                    }
                }){
                    Label("Add New Project", systemImage: "plus")
                }
            }
        }
    }
}

struct ProjectView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        ProjectView(showClosedProject: true).environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
