//
//  PostViewModel.swift
//  SportsFinder
//
//  Created by Christopher Kennedy on 4/22/23.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import UIKit

@MainActor

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
                let documentRef = try await db.collection(collectionString).addDocument(data: post.dictionary)
                self.post = post
                self.post.id = documentRef.documentID
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
    
    func saveImage(spot: Spot, post: Post, photo: Photo, image: UIImage) async -> Bool{
        guard let spotID = spot.id else{
            print("ERROR: spot.id == nil")
            return false
        }
        guard let postID = post.id else{
            print("ERROR: post.id == nil")
            return false
        }
        var photoName = UUID().uuidString // This will be the name of the image file
        if photo.id != nil{
            photoName = photo.id!
        }
        let storage = Storage.storage() // Create a firebase storage instance
        let storageRef = storage.reference().child("\(postID)/\(photoName).jpeg")
        
        guard let resizedImage = image.jpegData(compressionQuality: 0.2) else{
            print("ERROR: could not resize image")
            return false
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg" // setting metadata allows you to see console image in the web browser. This setting will work for png as well as jpeg
        
        var imageURLString = "" // we'll set this after the image is successfully saved
        
        do{
            let _ = try await storageRef.putDataAsync(resizedImage, metadata: metadata)
            print("Image Saved")
            do{
                let imageURL = try await storageRef.downloadURL()
                imageURLString = "\(imageURL)" // we'll save this to cloud firestore as part of documnent in photos collection before
            }
        } catch{
            print("ERROR: uploading image to FirebaseStorage")
            return false
        }
        // Now save to the photos collection of the spot document "spotID"
        let db = Firestore.firestore()
        let collectionString = "spots/\(spotID)/posts/\(postID)/photos"
        
        do{
            var newPhoto = photo
            newPhoto.imageURLString = imageURLString
            try await db.collection(collectionString).document(photoName).setData(newPhoto.dictionary)
            print("Data updated succesfully")
            return true
        } catch{
            print("ERROR: could not update data in 'photos' for spotID \(spotID) and postID \(postID)")
            return false
        }
    }
}

