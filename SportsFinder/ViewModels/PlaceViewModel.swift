//
//  PlaceViewModel.swift
//  SportsFinder
//
//  Created by Christopher Kennedy on 4/25/23.
//

import Foundation
import MapKit

@MainActor
class placeViewModel: ObservableObject{
    @Published var places: [Place] = []
    
    func search(text: String, region: MKCoordinateRegion){
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = text
        searchRequest.region = region
        let search = MKLocalSearch(request: searchRequest)
        
        search.start{ response, error in
            guard let response = response else{
                print("ERROR: \(error?.localizedDescription ?? "Unknown Error")")
                return
            }
            self.places = response.mapItems.map(Place.init)
        }
    }
}
