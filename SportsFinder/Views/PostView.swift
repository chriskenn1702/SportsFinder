//
//  PostView.swift
//  SportsFinder
//
//  Created by Christopher Kennedy on 4/26/23.
//

import SwiftUI
import MapKit
import Firebase
import FirebaseFirestoreSwift
import PhotosUI

struct PostView: View {
    @FirestoreQuery(collectionPath: "posts") var photos: [Photo]
    @EnvironmentObject var postVM: PostViewModel
    @State var newPhotos: [Photo] = []
    @State var post: Post
    @State var spot: Spot
    @State var newPhoto = Photo()
    let regionSize = 500.0
    @State var postedByThisUser = false
    @State var needEquipment = false
    @State var lookupPlacePresented = false
    @State private var showSaveAlert = false
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var uiImageSelected = UIImage()
    @State var previewRunning = false
    @State var showingAsSheet = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack{
            ScrollView{
                Group{
                    Text(post.title)
                        .font(.title)
                        .bold()
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("Action-Blue"))
                        .padding(.bottom)
                        .disabled(true)
                    
                    Button(post.address){
                        let url = URL(string: "maps://?saddr=&daddr=\(post.latitude),\(post.longitude)")
                        if UIApplication.shared.canOpenURL(url!) {
                              UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                        }
                    }
                    .font(.title3)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .tint(.green)
                    .padding(.bottom)
                    
                    HStack{
                        Text("Event Date:")
                            .foregroundColor(Color("Action-Blue"))
                        Text("\(post.date.formatted(date: .numeric, time: .shortened))")
                            .foregroundColor(Color("Sky-Blue"))
                    }
                    .padding(.bottom)
                }
                
                
                HStack{
                    Text("Difficulty: ")
                    DifficultyView(rating: $post.skill, interactive: false)
                        .padding(.bottom)
                }
                
                HStack{
                    
                    Text("Gender:")
                        .foregroundColor(Color("Action-Blue"))
                    Text("\(post.gender.capitalized)")
                        .foregroundColor(Color("Sky-Blue"))
                    
                    Text("Equipment Provided:")
                        .foregroundColor(Color("Action-Blue"))
                    Text("\(post.equipmentNeeded ? "Yes": "No")")
                        .foregroundColor(Color("Sky-Blue"))
                }
                
                HStack{
                    Text("Cost:")
                        .foregroundColor(Color("Action-Blue"))
                    Text("$\(post.cost)")
                        .foregroundColor(Color("Sky-Blue"))
                    Text("Age Range:")
                        .foregroundColor(Color("Action-Blue"))
                    Text("\(post.age)")
                        .foregroundColor(Color("Sky-Blue"))
                }
                .padding(.bottom)
                
                VStack(alignment: .leading){
                    
                    Text("Contact Information")
                        .bold()
                        .font(.title3)
                    Rectangle()
                        .frame(height: 1)
                    
                    HStack{
                        Text("Phone Number: ")
                            .foregroundColor(Color("Action-Blue"))
                        Button(post.telephone){
                            let url = URL(string: "sms://\(post.telephone)")
                            if UIApplication.shared.canOpenURL(url!) {
                                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                            }
                        }
                        .tint(.green)
                        Spacer()
                    }
                    
                    HStack{
                        Text("Email: ")
                            .foregroundColor(Color("Action-Blue"))
                        Button(post.email){//test on own phone
                            let email = post.email
                            if let url = URL(string: "mailto:\(email)") {
                                if #available(iOS 10.0, *) {
                                    UIApplication.shared.open(url)
                                } else {
                                    UIApplication.shared.openURL(url)
                                }
                            }
                        }
                        .tint(.green)
                        Spacer()
                    }
                    HStack{
                        Text("Website: ")
                            .foregroundColor(Color("Action-Blue"))
                        Link(post.link,
                             destination: URL(string: "https://\(post.link)/TOS.html")!)
                        .foregroundColor(.green)
                    }
                    Spacer()
                }
                .padding(.bottom)
                
                PhotoScrollView(photos: photos, post: post)
            
                
                
                Text(post.body)
                    .font(.body)
                    .multilineTextAlignment(.leading)
                    .padding()
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5), lineWidth: post.body == "" ? 0 : 2)
                    }
            }
            .toolbarBackground(Color("Sky-Blue"), for: .navigationBar) // only when scrolled down
            .navigationBarTitleDisplayMode(.inline)
        }
        
        .onAppear{
            if !previewRunning && post.id != nil{
                $photos.path = "spots/\(spot.id ?? "")/posts/\(post.id ?? "")/photos"
                print("photos.path = spots/\(spot.id ?? "")/post\(post.id ?? "")/photos")
            } else{
                showingAsSheet = true
            }
            if post.author == Auth.auth().currentUser?.email{
                postedByThisUser = true
            }
            
        }
        .padding()
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(post: Post(), spot: Spot(), previewRunning: true)
            .environmentObject(LocationManager())
    }
}

