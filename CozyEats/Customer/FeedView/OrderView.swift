//
//  OrderView.swift
//  CozyEats
//
//  Created by Benjamin Melville on 11/9/23.
//

import SwiftUI

@MainActor
final class OrderViewModel: ObservableObject {
    @Published private(set) var image: UIImage? = nil
    @Published private(set) var user: Customer? = nil
    
    
    func loadMenuImage(imageUrl: String) async throws {
        let data = try await StorageManager.shared.getImage(imageUrl: imageUrl)
        self.image = UIImage(data: data)
    }
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await CustomerManager.shared.getCustomer(userId: authDataResult.uid)
    }
    
    func addToCart(menuItem: MenuItem, quantity: Int) {
        
        guard let user else { return }
        
        

        Task {
            try await CustomerManager.shared.addToCart(userId: user.userId, menuItem: menuItem, quantity: quantity)
            self.user = try await CustomerManager.shared.getCustomer(userId: user.userId)
        }
    }
    
}




struct OrderView: View {
    
    @State var menuItem: MenuItem
    let seller: Seller
    
    @StateObject private var viewModel = OrderViewModel()
    @Environment(\.dismiss) var dismissScreen
    @State var quantity: Int = 0
    @State private var animate = false
    

    
    var body: some View {
        ZStack {
            Color.accent.ignoresSafeArea()
            ScrollView {
                
                
                VStack {
                    
                    Text("Time to eat.")
                        .font(.system(.largeTitle, design: .serif))
                        .fontWeight(.bold)
                        .padding(.bottom)
                        .padding(.top)
                    
                    HStack {
                        Text("\(seller.firstName ?? "") is selling ") +
                        
                        Text("\(menuItem.name).")
                            .font(.system(.title, design: .serif))
                            .fontWeight(.bold)
                    }
                    .font(.system(.title2, design: .serif))
                    
                    Divider()
                        .background(.secondary)
                    
                    HStack {
                        Text("here is what he has to say about it: ").fontWeight(.bold) +
                        Text("\(menuItem.description ?? "n/a")").fontWeight(.light)
                    }
                    .font(.system(.title2, design: .serif))
                    
                    
                    if let image = viewModel.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 400, height: 400)
                            .clipped()
                            .overlay(alignment: .bottomTrailing) {
                                FiveStarsView()
                                    .frame(width: 200)
                                    .background(.ultraThinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .padding(.bottom)
                                    .padding(.horizontal)
                            }
                    }
                    
                    
                    
                    
                    HStack {
                        Text("dietary restrictions: ").fontWeight(.bold) + Text("\(menuItem.dietaryRestrictions?.first ?? "n/a")")
                        
                        Spacer()
                        
                        
                        
                    }
                    .font(.system(.subheadline, design: .serif))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: 600, alignment: .leading)
                    .padding(.leading, 8)
                    
                    Divider()
                        .background(.secondary)
                    
                    HStack {
                        Text("$\(menuItem.price ?? 0)").font(.system(.title, design: .serif))
                        + Text(" per portion.").font(.system(.subheadline, design: .serif))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 8)
                    
                    Divider()
                        .background(.secondary)
                    
                    
                    Text("How much would you like to order?")
                        .font(.system(.title3, design: .serif))
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.leading, 8)
                        .padding(.bottom, 20)

                    
                    Stepper("\(quantity)", value: $quantity)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 90)
                    
                        .font(.system(.title2, design: .serif))
                        .padding(.bottom, 25)
                        .padding(.leading, 8)
                        .padding(.horizontal)
                    
                    Divider()
                        .background(.secondary)
                    
                    Text("total: $\(quantity * (menuItem.price ?? 1))")
                        .font(.system(.title, design: .serif))
                        .fontWeight(.semibold)
                        .padding(.bottom, 25)

                    
                    
                    
                    
                    Spacer()
                    
                    
                    
                    Button {
                        
                        if let user = viewModel.user {
                            menuItem.quantity = quantity
                            viewModel.addToCart(menuItem: menuItem, quantity: quantity)
                        }
                        dismissScreen()
                        
                    } label: {
                        Text("add to cart")
                            .font(.system(.title2, design: .serif))
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .foregroundStyle(.white)
                            .background(.green)
                            .clipShape(RoundedRectangle(cornerRadius: 12.0))
                            .padding(.horizontal, animate ? 30 : 50)
                            .shadow(color: animate ? .green.opacity(0.6) : .accent.opacity(0.6),
                                    radius: animate ? 30 : 10,
                                    x: 0.0,
                                    y: animate ? 50 : 30)
                            .scaleEffect(animate ? 1.1 : 1.0)
                            .offset(y: animate ? -10 : 0)

                    }
                    .onAppear {
                        addAnimation()
                    }
                    
                    
                    
                    
                    
                }
                .padding(.horizontal, 8)
                
                
            }
            .task {
                try? await viewModel.loadMenuImage(imageUrl: menuItem.images.first ?? "")
                try? await viewModel.loadCurrentUser()
            }

        }
    }
    
    
    func addAnimation() {
        guard !animate else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(
                Animation
                    .easeInOut(duration: 2.0)
                    .repeatForever()
            
            ) {
                animate.toggle()
            }
        }
    }
    
}

#Preview {
    NavigationStack {
        OrderView(menuItem: MenuItem(name: "lassagna", price: 23, description: "this food is so flipping good dawg", cuisine: "Italian", images: ["tU8uEBX40sRUvc9VuBJ8DVfmaHG2/tacos/7913E4CC-6788-48D3-9C63-F73FA911C4FE.jpeg"]), seller: Seller(firstName: "bruce", lastName: "wayne", userId: "asdfouyastasdfv", dateCreated: Date(), email: "batman@gmail.com", photoUrl: "", menu: nil))
    }
}
