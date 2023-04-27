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

enum Gender: String, CaseIterable, Codable {
    case mixed, male, female
}

struct Post: Identifiable, Codable, Equatable{
    @DocumentID var id: String?
    var title = ""
    var body = ""
    var email = ""
    var telephone = ""
    var name = ""
    var address = ""
    var link = ""
    var skill = 1
    var cost = ""
    var age = ""
    var equipmentNeeded = false
    var gender = Gender.mixed.rawValue
    var date = Date.now + 60*60*48
    var postedOn = Date()
    var author = Auth.auth().currentUser?.email ?? ""
    var latitude = 0.0
    var longitude = 0.0
    var coordiate: CLLocationCoordinate2D{
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var dictionary: [String: Any]{
        return ["title": title, "body": body, "email": email,"telephone":telephone, "name":name, "address":address, "link":link, "skill":skill, "cost":cost, "age":age, "equipmentNeeded":equipmentNeeded, "gender":gender, "date": date, "postedOn":postedOn, "author":author, "latitude":latitude, "longitude": longitude]
    }
}
