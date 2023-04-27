//
//  PhotoView.swift
//  SportsFinder
//
//  Created by Christopher Kennedy on 4/27/23.
//

import SwiftUI

struct PhotoView: View {
    var uiImage: UIImage
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack{
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .navigationBarTitleDisplayMode(.inline)
        }
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
}

struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoView(uiImage: UIImage(named: "Sports Finder-2") ?? UIImage())
    }
}
