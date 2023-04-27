//
//  PhotoScrollView.swift
//  SportsFinder
//
//  Created by Christopher Kennedy on 4/25/23.
//

import SwiftUI

import SwiftUI

struct PhotoScrollView: View {
//    struct FakePhoto: Identifiable{
//        let id = UUID().uuidString
//        var imageURLString = "https://firebasestorage.googleapis.com:443/v0/b/snacktacular-78ce0.appspot.com/o/2IEgxya1596kHX4HyGTD%2FBDD20F4F-85F9-4F93-95CB-00FE43E1BAEA.jpeg?alt=media&token=7f75a736-4d16-4c31-be16-a196a9dd5678"
//    }
//
//    let photos = [FakePhoto(), FakePhoto(), FakePhoto(), FakePhoto(), FakePhoto(), FakePhoto(), FakePhoto(), FakePhoto()]
    @State private var showPhotoViewerView = false
    @State private var uiImage = UIImage()
    @State private var selectedPhoto = Photo()
    var photos: [Photo]
    var post: Post
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack(spacing: 4){
                ForEach(photos) { photo in
                    let imageURL = URL(string: photo.imageURLString) ?? URL(string: "")
                    
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipped()
                    } placeholder: {
                       ProgressView()
                            .frame(width: 80, height: 80)
                    }

                }
            }
        }
        .frame(height: 80)
        .padding(.horizontal, 4)
    }
}

struct SpotDetailPhotoScrollView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoScrollView(photos: [Photo(imageURLString: "https://firebasestorage.googleapis.com:443/v0/b/snacktacular-78ce0.appspot.com/o/2IEgxya1596kHX4HyGTD%2FBDD20F4F-85F9-4F93-95CB-00FE43E1BAEA.jpeg?alt=media&token=7f75a736-4d16-4c31-be16-a196a9dd5678")], post: Post(id: "2IEgxya1596kHX4HyGTD"))
    }
}
