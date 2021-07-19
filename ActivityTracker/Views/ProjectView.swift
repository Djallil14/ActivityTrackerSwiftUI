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
                    Section(header: Text(project.projectTitle)){
                        ForEach(project.projectItems){item in
                            Text(item.itemTitle)
                        }
                    }
                }
            }.listStyle(InsetGroupedListStyle())
            .navigationTitle(showClosedProject ? "Closed Projects" : "Open Projects")
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
