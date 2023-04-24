//
//  PostView.swift
//  SportsFinder
//
//  Created by Christopher Kennedy on 4/22/23.
//

import SwiftUI
import Firebase

struct PostView: View {
    @EnvironmentObject var postVM: PostViewModel
    @State var post: Post
    @State var spot: Spot
    @State var postedByThisUser = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack{
            Group{
                TextField("Title", text: $post.title)
                    .font(.title)
                TextField("Address", text: $post.address)
                    .font(.title)
            }
            .disabled(spot.id == nil ? false: true)
            .textFieldStyle(.roundedBorder)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray.opacity(0.5), lineWidth: spot.id == nil ? 2: 0)
            }
            Spacer()
            
        }
        .onAppear{
            if post.author == Auth.auth().currentUser?.email{
                postedByThisUser = true
            }
        }
        .toolbar {
            if postedByThisUser{
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        Task{
                            let success = await postVM.savePost(spot: spot, post: post)
                            if success{
                                dismiss()
                            } else{
                                print("ERROR saving data in ReviewView")
                            }
                        }
                    }
                }
                if post.id != nil{
                    ToolbarItemGroup(placement: .bottomBar) {
                        Spacer()
                        Button {
                            Task{
                                let success =  await postVM.deletePost(spot: spot, post: post)
                                if success{
                                    dismiss()
                                }
                            }
                            
                        } label: {
                            Image(systemName: "trash")
                        }

                    }
                }
            }
            
        }
        .padding()
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(post: Post(title: "", body: "Test Body", email: "Test Email", date: Date(), postedOn: Date()), spot: Spot())
            .environmentObject(PostViewModel())
    }
}
