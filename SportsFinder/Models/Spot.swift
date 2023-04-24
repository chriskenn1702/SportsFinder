//
//  Spot.swift
//  SportsFinder
//
//  Created by Christopher Kennedy on 4/22/23.
//

import Foundation
import FirebaseFirestoreSwift
import CoreLocation

struct Spot: Identifiable, Codable, Equatable{
    @DocumentID var id: String?
    var sport = ""
    
    var dictionary: [String: Any]{
        return ["sport": sport]
    }
}
