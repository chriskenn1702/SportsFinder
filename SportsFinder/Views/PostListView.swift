//
//  PostListView.swift
//  SportsFinder
//
//  Created by Christopher Kennedy on 4/22/23.
//

import SwiftUI

struct PostListView: View {
    @State var spot: Spot
    @State var posts = ["2 Men for Mens team", "Open Ice Time", "Tryouts", "Pond Hockey"]
    @State var sheetIsPresented = false
    var body: some View {
        NavigationStack{
            List(posts, id: \.self) { post in
                NavigationLink {
                    PostView(post: Post(), spot: spot)
                } label: {
                    Text(post)
                        .font(.title)
                        .padding(2)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Posts")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        sheetIsPresented.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }

                }
            }
        }
        .sheet(isPresented: $sheetIsPresented) {
            NavigationStack{
                PostView(post: Post(), spot: spot)
            }
        }
    }
}

struct PostListView_Previews: PreviewProvider {
    static var previews: some View {
        PostListView(spot: Spot())
    }
}
