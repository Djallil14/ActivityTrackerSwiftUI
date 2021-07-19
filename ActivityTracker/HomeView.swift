//
//  HomeView.swift
//  ActivityTracker
//
//  Created by Djallil Elkebir on 2021-07-19.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var dataController: DataController
    var body: some View {
        NavigationView {
            VStack {
                Text("Hello, World!")
                Button(action: {
                    dataController.deleteAll()
                    try? dataController.createSampleData()
                }, label: {
                    Text("Add Data")
                })
            }.navigationTitle("Home")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        HomeView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
    }
}
