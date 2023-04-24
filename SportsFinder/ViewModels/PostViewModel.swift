//
//  PostViewModel.swift
//  SportsFinder
//
//  Created by Christopher Kennedy on 4/22/23.
//

import Foundation
import FirebaseFirestore

class PostViewModel: ObservableObject{
    @Published var post = Post()
    
    func savePost(spot: Spot, post: Post) async -> Bool{
        let db = Firestore.firestore()
        
        guard let spotID = spot.id else{
            print("ERROR: spot.id = nil")
            return false
            
        }
        let collectionString = "spots/\(spotID)/posts"
        
        if let id = post.id{
            do{
                try await db.collection(collectionString).document(id).setData(post.dictionary)
                print("Data updated succesfully!")
                return true
            } catch{
                print("ERROR: Could not update data in 'posts' \(error.localizedDescription)")
                return false
            }
        } else{
            do{
                _ = try await db.collection(collectionString).addDocument(data: post.dictionary)
                print("Data added succesfully!")
                return true
            } catch{
                print("ERROR: Could not could not create a new spot in 'posts' \(error.localizedDescription)")
                return false
            }
        }
    }
    
    func deletePost(spot: Spot, post: Post) async -> Bool{
        let db  = Firestore.firestore()
        guard let spotID = spot.id, let postID = post.id else{
            print("ERROR: spot.id = \(spot.id ?? "nil"), post.id = \(post.id ?? "nil")")
            return false
        }
        do {
            let _ = try await db.collection("spots").document(spotID).collection("posts").document(postID).delete()
            print("Document succesfully deleted")
            return true
        } catch{
            print("ERROR: removing document \(error.localizedDescription)")
            return false
        }
    }
}

