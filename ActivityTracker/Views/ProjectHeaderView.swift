//
//  ProjectHeaderView.swift
//  ActivityTracker
//
//  Created by Djallil Elkebir on 2021-07-19.
//

import SwiftUI

struct ProjectHeaderView: View {
    @ObservedObject var project: Project
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(project.projectTitle)
                ProgressView(value: project.completionAmount)
                    .accentColor(Color(project.projectColor))
            }
            Spacer()
            NavigationLink(destination: EditProjectView(project: project)){
                Image(systemName: "square.and.pencil")
                    .imageScale(.large)
            }
        }.padding(.bottom, 10)
    }
}

struct ProjectHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectHeaderView(project: Project.example)
    }
}
