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
    @Environment(\.dismiss) private var dismiss
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
            .background(Color("Sky-Blue"))
            .listStyle(.plain)
            .toolbarBackground(Color("Sky-Blue"), for: .navigationBar)
            .navigationTitle("Sports")
            .navigationBarTitleDisplayMode(.inline)
            
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Sign Out") {
                        do{
                            try Auth.auth().signOut()
                            print("🪵 Log out succesful")
                            dismiss()
                        } catch{
                            print("🤬 ERROR: Could not sign out!")
                        }
                    }
                }
            }
        }
        
    }
}

struct SportsListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            SportsListView()
        }
    }
}
