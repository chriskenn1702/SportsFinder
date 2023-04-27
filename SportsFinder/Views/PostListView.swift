//
//  PostListView.swift
//  SportsFinder
//
//  Created by Christopher Kennedy on 4/22/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct PostListView: View {
    @State var spot: Spot
    @FirestoreQuery(collectionPath: "spots") var posts: [Post]
    //@State var posts = ["2 Men for Mens team", "Open Ice Time", "Tryouts", "Pond Hockey"]
    @State var sheetIsPresented = false
    var body: some View {
        NavigationStack{
            List(posts) { post in
                NavigationLink {
                    if post.author == Auth.auth().currentUser?.email{
                            NewPostView(post: post, spot: spot)
                    }
                    else{
                            PostView(post: post, spot: spot)
                    }
                } label: {
                    VStack(alignment: .leading){//Figure this out
                        Text(post.title)
                            .font(.title)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.leading)
                        HStack{
                            Text("Posted on:")
                            Text("\(post.date.formatted(date: .numeric, time: .omitted))")
                        }
                        .multilineTextAlignment(.leading)
                    }
                }
            }
            .listStyle(.plain)
            .background(Color("Sky-Blue")) //
            .toolbarBackground(Color("Sky-Blue"), for: .navigationBar)
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
        .onAppear{
            $posts.path = "spots/\(spot.id ?? "")/posts"
            print("post.path = \($posts.path)")
        }
        .sheet(isPresented: $sheetIsPresented) {
            NavigationStack{
                NewPostView(post: Post(), spot: spot)
            }
        }
    }
}

struct PostListView_Previews: PreviewProvider {
    static var previews: some View {
        PostListView(spot: Spot())
    }
}
