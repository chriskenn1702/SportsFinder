//
//  Photo.swift
//  SportsFinder
//
//  Created by Christopher Kennedy on 4/25/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Photo: Identifiable, Codable{
    @DocumentID var id: String?
    var imageURLString = ""
    
    var dictionary: [String: Any]{
        return ["imageURLString": imageURLString]
    }
}
