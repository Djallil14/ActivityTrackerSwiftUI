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
    
    var body: some View {
        NavigationView {
            Group {
                if !projects.wrappedValue.isEmpty {
                    List {
                        ForEach(projects.wrappedValue){ project in
                            Section(header: ProjectHeaderView(project: project)){
                                ForEach(items(for: project)){item in
                                    ItemRowView(project: project, item: item)
                                }.onDelete{offsets in
                                    let allItems = items(for: project)
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
                } else {
                    Text("There's nothing here right now")
                        .foregroundColor(.secondary)
                }
            }
            
            .navigationTitle(showClosedProject ? "Closed Projects" : "Open Projects")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if showClosedProject == false {
                        Button {
                            withAnimation {
                                let project = Project(context: managedObjectContext)
                                project.closed = false
                                project.creationDate = Date()
                                dataController.save()
                            }
                        } label: {
                            Label("Add Project", systemImage: "plus")
                        }
                    }
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSortOrder.toggle()
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                }
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
}

struct ProjectView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        ProjectView(showClosedProject: true).environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}

