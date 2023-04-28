//
//  NewPostView.swift
//  SportsFinder
//
//  Created by Christopher Kennedy on 4/22/23.
//

import SwiftUI
import MapKit
import Firebase
import FirebaseFirestoreSwift
import PhotosUI

struct NewPostView: View {
    struct Annotation: Identifiable{
        let id = UUID().uuidString
        var name: String
        var address: String
        var coordinate: CLLocationCoordinate2D
    }
    @FirestoreQuery(collectionPath: "posts") var photos: [Photo]
    @EnvironmentObject var postVM: PostViewModel
    @EnvironmentObject var locationManager: LocationManager
    @State var newPhotos: [Photo] = []
    @State var post: Post
    @State var spot: Spot
    @State var newPhoto = Photo()
    @State private var annotations: [Annotation] = []
    let regionSize = 500.0
    @State var postedByThisUser = false
    @State var needEquipment = false
    @State var lookupPlacePresented = false
    @State private var showSaveAlert = false
    @State private var mapRegion = MKCoordinateRegion()
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var uiImageSelected = UIImage()
    @State var previewRunning = false
    @State var showingAsSheet = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack{
            ScrollView{
                Group{
                    TextField("Post Title", text: $post.title)
                        .font(.title)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray.opacity(0.5), lineWidth: 2)
                        }
                        .padding(.bottom)
                    HStack{
                        TextField("Event Address", text: $post.address)
                            .font(.title)
                            .overlay {
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.gray.opacity(0.5), lineWidth: 2)
                            }
                        Button("Search"){
                            lookupPlacePresented.toggle()
                        }
                    }
                    .padding(.bottom)
                    
                    DatePicker("Event Date", selection: $post.date)
                        .padding(.bottom)
                        .foregroundColor(Color("Action-Blue"))
                }
                
                
                HStack{
                    Text("Difficulty: ")
                        .foregroundColor(Color("Action-Blue"))
                    DifficultyView(rating: $post.skill, interactive: true)
                        .padding(.bottom)
                }
                
                HStack{
                    
                    Text("Gender")
                        .foregroundColor(Color("Action-Blue"))
                    Picker("", selection: $post.gender) {
                        ForEach(Gender.allCases, id: \.self) { gender in
                            Text(gender.rawValue.capitalized)
                                .tag(gender.rawValue)
                        }
                    }
                    Text("Equipment Provided?")
                        .foregroundColor(Color("Action-Blue"))
                    Toggle("", isOn: $post.equipmentNeeded)
                }
                .padding(.bottom)
                
                HStack{
                    TextField("Cost", text: $post.cost)
                        .font(.title)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray.opacity(0.5), lineWidth: 2)
                        }
                        .keyboardType(.numberPad)
                    TextField("Age Range", text: $post.age)
                        .font(.title)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray.opacity(0.5), lineWidth: 2)
                        }
                }
                
                Group{
                    
                    Text("Contact Information") //Make Leading
                        .bold()
                        .font(.title3)
                        .foregroundColor(Color("Action-Blue"))

                    
                    TextField("Phone Number", text: $post.telephone)
                        .font(.title)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray.opacity(0.5), lineWidth: 2)
                        }
                        .padding(.bottom)
                        .keyboardType(.phonePad)
                    
                    TextField("Email", text: $post.email)
                        .font(.title)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray.opacity(0.5), lineWidth: 2)
                        }
                        .keyboardType(.emailAddress)
                        .padding(.bottom)
                    
                    TextField("Link", text: $post.link)
                        .font(.title)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray.opacity(0.5), lineWidth: 2)
                        }
                        .keyboardType(.webSearch)
                        .padding(.bottom)
                }
                
                Group {
                    PhotoScrollView(photos: photos, post: post)
                    PhotosPicker(selection: $selectedPhoto, matching: .images, preferredItemEncoding: .automatic) {
                        Image(systemName: "photo")
                        Text("Add Photo")
                    }
                    .onChange(of: selectedPhoto) { newValue in
                        Task{
                            do{
                                if let data = try await newValue?.loadTransferable(type: Data.self){
                                    if let uiImage = UIImage(data: data){
                                        uiImageSelected = uiImage
                                        print("Selected image")
                                        newPhoto = Photo()
                                        if post.id == nil{
                                            showSaveAlert.toggle()
                                        } else{
                                            Task{
                                                let _ = await postVM.saveImage(spot:spot, post: post, photo: newPhoto, image: uiImage)
                                            }
                                        }
                                    }
                                }
                            } catch{
                                print("ERROR: selecting image failed \(error.localizedDescription)")
                            }
                        }
                    }
                }
                
                
                TextField("Post Description", text: $post.body, axis: .vertical) //Why won't it stretch?
                    .font(.title)
                    .lineLimit(5, reservesSpace: true)
                    .overlay {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(.gray.opacity(0.5), lineWidth: 2)
                    }
            }
            
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
        }
        
        .onAppear{
            if !previewRunning && post.id != nil{
                $photos.path = "spots/\(spot.id ?? "")/posts/\(post.id ?? "")/photos"
                print("reviews.path = spots/\(spot.id ?? "")/post\(post.id ?? "")/photos")
                
                
            } else{
                showingAsSheet = true
            }
            if post.author == Auth.auth().currentUser?.email{
                postedByThisUser = true
            }
            if post.id != nil{
                mapRegion = MKCoordinateRegion(center: post.coordiate, latitudinalMeters: regionSize, longitudinalMeters: regionSize)
            } else{
                Task{
                    mapRegion = MKCoordinateRegion(center: locationManager.location?.coordinate ?? CLLocationCoordinate2D(), latitudinalMeters: regionSize, longitudinalMeters: regionSize)
                    locationManager.region = mapRegion
                }
            }
            annotations = [Annotation(name: post.name, address: post.address, coordinate: post.coordiate)]
            
        }
        .sheet(isPresented: $lookupPlacePresented, content: {
            PlaceLookUpView(post: $post)
        })
        .alert("Cannot Rate Place Unless It is Saved", isPresented: $showSaveAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Save", role: .none) {
                Task{
                    let success = await postVM.savePost(spot: spot, post: post)
                    post = postVM.post
                    print(post.id ?? "No ID")
                    if success{
                        $photos.path = "spots/\(spot.id ?? "")/posts/\(post.id ?? "")/photos"
                        print($photos.path)
                        Task{
                            let _ = await postVM.saveImage(spot:spot, post: post, photo: newPhoto, image: uiImageSelected)
                        }
                    } else{
                        print("DANG! Error saving spot")
                    }
                }
            }
        } message: {
            Text("Would you like to save this alert first so that you can enter a review?")
        }
        .toolbar {
            if postedByThisUser{
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        Task{
                            let success = await postVM.savePost(spot: spot, post: post)
                            if success{
                                dismiss()
                            } else{
                                print("ERROR saving data in ReviewView")
                            }
                        }
                    }
                }
                if post.id != nil{
                    ToolbarItemGroup(placement: .bottomBar) {
                        Spacer()
                        Button {
                            Task{
                                let success =  await postVM.deletePost(spot: spot, post: post)
                                if success{
                                    dismiss()
                                }
                            }
                            
                        } label: {
                            Image(systemName: "trash")
                        }
                        
                    }
                }
            }
            
        }
        .padding()
    }
}

struct NewPostView_Previews: PreviewProvider {
    static var previews: some View {
        NewPostView(post: Post(), spot: Spot(), previewRunning: true)
            .environmentObject(LocationManager())
    }
}
