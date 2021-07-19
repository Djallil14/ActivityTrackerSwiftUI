//
//  ContentView.swift
//  ActivityTracker
//
//  Created by Djallil Elkebir on 2021-07-19.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            HomeView().tabItem { Label("Home", systemImage: "house") }
            ProjectView(showClosedProject: false).tabItem { Label("Open", systemImage: "list.bullet") }
            ProjectView(showClosedProject: true).tabItem { Label("Closed", systemImage: "checkmark") }
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
