//
//  SportsListView.swift
//  SportsFinder
//
//  Created by Christopher Kennedy on 4/22/23.
//

import SwiftUI

struct SportsListView: View {
    @State var sports = ["Hockey", "Football", "Basketball", "Baseball"]
    var body: some View {
        NavigationStack{
            List(sports, id: \.self) { sport in
                NavigationLink {
                    PostListView()
                } label: {
                    Text(sport)
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
