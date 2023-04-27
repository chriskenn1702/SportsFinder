//
//  PlaceLookUpView.swift
//  SportsFinder
//
//  Created by Christopher Kennedy on 4/25/23.
//

import SwiftUI
import MapKit

struct PlaceLookUpView: View {
    @EnvironmentObject var locationManager: LocationManager
    @StateObject var placeVM = placeViewModel()
    @State private var searchText = ""
    @Binding var post: Post
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack{
            List(placeVM.places){place in
                VStack (alignment: .leading) {
                    Text(place.name)
                        .font(.title)
                    Text(place.address)
                        .font(.callout)
                }
                .onTapGesture {
                    post.address = place.address
                    post.longitude = place.longitude
                    post.latitude = place.latitude
                    dismiss()
                }
            }
            .listStyle(.plain)
            .searchable(text: $searchText)
            .onChange(of: searchText, perform: { text in
                if !text.isEmpty{
                    placeVM.search(text: text, region: locationManager.region)
                } else{
                    placeVM.places = []
                }
            })
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Dismiss"){
                        dismiss()
                    }
                }
            }
        }
    }
}

struct PlaceLookUpView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceLookUpView(post: .constant(Post()))
            .environmentObject(LocationManager())
    }
}
