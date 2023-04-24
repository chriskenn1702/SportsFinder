//
//  SportsListView.swift
//  SportsFinder
//
//  Created by Christopher Kennedy on 4/22/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct SportsListView: View {
    @FirestoreQuery(collectionPath: "spots") var spots: [Spot]
    var body: some View {
        NavigationStack{
            List(spots) { spot in
                NavigationLink {
                    PostListView(spot: spot)
                } label: {
                    Text(spot.sport)
                        .font(.title)
                        .padding(2)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Sports")
        }
    }
}

struct SportsListView_Previews: PreviewProvider {
    static var previews: some View {
        SportsListView()
    }
}
