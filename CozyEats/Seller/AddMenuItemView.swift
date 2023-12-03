//
//  AddMenuItemView.swift
//  CozyEats
//
//  Created by Benjamin Melville on 10/16/23.
//

import SwiftUI
import PhotosUI

@MainActor
final class AddMenuItemViewModel: ObservableObject {
    
    @Published private(set) var user: Seller? = nil
    
    @Published private(set) var selectedImages: [UIImage] = []
    
    @Published var imageSelections: [PhotosPickerItem] = [] {
        didSet {
            setImages(from: imageSelections)
        }
    }
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await SellerManager.shared.getSeller(userId: authDataResult.uid)
        print(self.user ?? "not working")
    }
    
    func addMenuItem(name: String, price: Int, description: String, cuisine: String) {
        guard let user else { return }

        
        Task {
            let images = try await addMenuImages(menuItemName: name)
            print(images)
            let menuItem = MenuItem(name: name, price: price, description: description, cuisine: cuisine, images: images)
            print(menuItem)
            try await SellerManager.shared.addMenuItem(userId: user.userId, menuItem: menuItem)
            self.user = try await SellerManager.shared.getSeller(userId: user.userId)
        }
        
        
        
    }
    
    
    func addMenuImages(menuItemName: String) async throws -> [String] {
        
        guard let user else { return ["no user"]}
        
        do {
            var imageUrls: [String] = []
            for image in selectedImages {
                if let data = image.jpegData(compressionQuality: 0.25) {
                    let imageUrl = try await StorageManager.shared.saveImage(userId: user.userId, menuItemName: menuItemName, data: data)
                    imageUrls.append(imageUrl)
                    print(imageUrl)
                }
            }
            print(imageUrls)
            return imageUrls
            
        } catch {
            print(error)
            return ["catch"]
        }
    }
    
    
    private func setImages(from selections: [PhotosPickerItem]) {
        Task {
            var images: [UIImage] = []
            for selection in selections {
                if let data = try? await selection.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        images.append(uiImage)
                    }
                }
            }
            
            self.selectedImages = images
        }
    }
    
    
}


struct AddMenuItemView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var viewModel = AddMenuItemViewModel()
    
    @State var name = ""
    @State var price = 0
    @State var description = ""
    @State var cuisine = ""
    
    private var numberFormatter = NumberFormatter()
    
    init() {
        numberFormatter.zeroSymbol = ""
    }
    
    
    var body: some View {
        
        ZStack {
            
            Color.tan.ignoresSafeArea()
            
            VStack(spacing: 20) {
                //            if let user = viewModel.user {
                Group {
                    TextField("name...", text: $name)
                    TextField("price...", value: $price, formatter: numberFormatter)
                    TextField("description...", text: $description)
                    TextField("cuisine...", text: $cuisine)
                    
                }
                .font(.headline)
                .padding(.leading)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                
                
                if !viewModel.selectedImages.isEmpty {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(viewModel.selectedImages, id: \.self) { image in
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(10.0)
                            }
                        }
                    }
                }
                
                PhotosPicker(selection: $viewModel.imageSelections, matching: .images) {
                    if !viewModel.selectedImages.isEmpty {
                        Text("add more images")
                    } else {
                        Text("add images")
                    }
                }
                                
                
                
                Button {
                    Task {
                        viewModel.addMenuItem(name: name, price: price, description: description, cuisine: cuisine)
                    }
                    withAnimation {
                        dismiss()
                    }
                    
                } label: {
                    Text("add dish")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.primary)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.accent)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                        .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .navigationTitle("Add dish")
            .task {
                try? await viewModel.loadCurrentUser()
            }
        }
        
        
    }
}

#Preview {
    NavigationStack {
        AddMenuItemView()
    }
}
