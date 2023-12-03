//
//  MenuItemCardView.swift
//  CozyEats
//
//  Created by Benjamin Melville on 10/16/23.
//

import SwiftUI


@MainActor
final class MenuItemCardViewModel: ObservableObject {
    
    @Published private(set) var user: Seller? = nil
    @Published private(set) var image: UIImage? = nil
        
//    func getImage(imageUrl: String) async throws {
//        let data = try await StorageManager.shared.getImage(imageUrl: imageUrl)
//        self.image = UIImage(data: data)
//        
//    }
    
    
    func loadCurrentUser(imageUrl: String) async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await SellerManager.shared.getSeller(userId: authDataResult.uid)
        print("downloading...")
        let data = try await StorageManager.shared.getImage(imageUrl: imageUrl)
        self.image = UIImage(data: data)
        print("download success!!!")
    }
    
}


struct MenuItemCardView: View {
    @StateObject private var viewModel = MenuItemCardViewModel()
    
    @State var menu: MenuItem
    @State private var imageData: Data? = nil
    
    var body: some View {
        VStack {
            if let user = viewModel.user, let image = viewModel.image
            {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                
                
                    .overlay(alignment: .topLeading) {
                        VStack {
                            Text(menu.cuisine ?? "")
                                .padding()
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        .padding()
                    }
                    .overlay(alignment: .bottom) {
                        VStack(alignment: .leading) {
                            Group {
                                Text(menu.name)
                                    .font(.largeTitle)
                                    .fontWeight(.medium)
                                    .foregroundStyle(Color.primary)
                                
                                Text("$\(menu.price ?? 0)")
                                    .font(.title3)
                                    .fontWeight(.regular)
                                    .foregroundStyle(Color.secondary)
                            }
                            .padding(.horizontal)
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 100)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
            }
        }
        .task {
            if !menu.images.isEmpty {
                try? await viewModel.loadCurrentUser(imageUrl: menu.images.first!)
            }
        }
        
    }
}


#Preview {
    MenuItemCardView(menu: MenuItem(name: "Lasagna", price: 12, description: "This lasagna is very tasty", cuisine: "Italian", images: ["lasagna"]))
}
