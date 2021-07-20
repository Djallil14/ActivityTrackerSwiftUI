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
    @State private var showingSortOrder = false
    
    @State private var sortOrder = Item.SortOrder.optimized
    
    
    let showClosedProject: Bool
    let projects: FetchRequest<Project>
    
    init(showClosedProject: Bool){
        self.showClosedProject = showClosedProject
        projects = FetchRequest<Project>(entity: Project.entity(), sortDescriptors: [
            NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)
        ], predicate: NSPredicate(format: "closed = %d", showClosedProject))
    }
    
    var projectsList: some View {
        List {
            ForEach(projects.wrappedValue){ project in
                Section(header: ProjectHeaderView(project: project)){
                    ForEach(items(for: project)){item in
                        ItemRowView(project: project, item: item)
                    }.onDelete{offsets in
                        deleteItem(offsets, from: project)
                    }
                    if showClosedProject == false {
                        Button(action: {
                            addItem(to: project)
                        }){
                            if UIAccessibility.isVoiceOverRunning {
                                Text("Add Project")
                            } else {
                                Label("Add Project", systemImage: "plus")
                            }
                        }
                    }
                }
            }
        }.listStyle(InsetGroupedListStyle())
    }
    
    var addProjectToolbarItem: some ToolbarContent{
        ToolbarItem(placement: .navigationBarTrailing) {
            if showClosedProject == false {
                Button {
                    addProject()
                } label: {
                    Label("Add Project", systemImage: "plus")
                }
            }
        }
    }
    var sortOrderToolbarItem: some ToolbarContent{
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                showingSortOrder.toggle()
            } label: {
                Label("Sort", systemImage: "arrow.up.arrow.down")
            }
        }
    }
    var body: some View {
        NavigationView {
            Group {
                if !projects.wrappedValue.isEmpty {
                    projectsList
                } else {
                    Text("There's nothing here right now")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle(showClosedProject ? "Closed Projects" : "Open Projects")
            .toolbar {
                addProjectToolbarItem
                sortOrderToolbarItem
            }
            .actionSheet(isPresented: $showingSortOrder) {
                ActionSheet(title: Text("Sort items"), message: nil, buttons: [
                    .default(Text("Optimized")) { sortOrder = .optimized },
                    .default(Text("Creation Date")) { sortOrder = .creationDate },
                    .default(Text("Title")) { sortOrder = .title }
                ])
            }
            SelectSomethingView()
        }
    }
    
    func addProject(){
        withAnimation {
            let project = Project(context: managedObjectContext)
            project.closed = false
            project.creationDate = Date()
            dataController.save()
        }
    }
    
    func items(for project: Project) -> [Item] {
        switch sortOrder {
        case .title:
            return project.projectItems.sorted { $0.itemTitle < $1.itemTitle }
        case .creationDate:
            return project.projectItems.sorted { $0.itemCreationDate < $1.itemCreationDate }
        case .optimized:
            return project.projectItemsDefaultSorted
        }
    }
    
    func addItem(to project: Project){
        withAnimation{
            if showClosedProject == false {
                let item = Item(context: managedObjectContext)
                item.project = project
                item.creationDate = Date()
                dataController.save()
            }
        }
    }
    
    func deleteItem(_ offsets: IndexSet,from project: Project){
        let allItems = items(for: project)
        for offset in offsets {
            let item = allItems[offset]
            dataController.delete(item)
        }
        dataController.save()
    }
}

struct ProjectView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        ProjectView(showClosedProject: true).environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}

