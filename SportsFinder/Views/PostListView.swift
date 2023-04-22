//
//  PostListView.swift
//  SportsFinder
//
//  Created by Christopher Kennedy on 4/22/23.
//

import SwiftUI

struct PostListView: View {
    @State var posts = ["2 Men for Mens team", "Open Ice Time", "Tryouts", "Pond Hockey"]
    var body: some View {
        NavigationStack{
            List(posts, id: \.self) { post in
                Text(post)
                    .font(.title)
                    .padding(2)
            }
            .listStyle(.plain)
            .navigationTitle("Posts")
        }
    }
}

struct PostListView_Previews: PreviewProvider {
    static var previews: some View {
        PostListView()
    }
}
