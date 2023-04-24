//
//  Post.swift
//  SportsFinder
//
//  Created by Christopher Kennedy on 4/22/23.
//

import Foundation
import FirebaseFirestoreSwift
import CoreLocation
import Firebase

struct Post: Identifiable, Codable, Equatable{
    @DocumentID var id: String?
    var title = ""
    var body = ""
    var email = ""
    var telephone = ""
    var address = ""
    var date = Date.now + 60*60*48
    var postedOn = Date()
    var author = Auth.auth().currentUser?.email ?? ""
    
    var dictionary: [String: Any]{
        return ["title": title, "body": body, "email": email, "date": date, "postedOn":postedOn, "author":author]
    }
}
