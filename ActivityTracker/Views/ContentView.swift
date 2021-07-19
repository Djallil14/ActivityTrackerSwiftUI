//
//  ContentView.swift
//  ActivityTracker
//
//  Created by Djallil Elkebir on 2021-07-19.
//

import SwiftUI

struct ContentView: View {
    @SceneStorage("selectedView") var selectedView: String?
    var body: some View {
        TabView(selection: $selectedView){
            HomeView().tabItem { Label("Home", systemImage: "house") }
                .tag(HomeView.homeTag)
            ProjectView(showClosedProject: false)
                .tag(ProjectView.openTag)
                .tabItem { Label("Open", systemImage: "list.bullet") }
            
            ProjectView(showClosedProject: true)
                .tag(ProjectView.closedTag)
                .tabItem { Label("Closed", systemImage: "checkmark") }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}

