//
//  HomeView.swift
//  CozyEats
//
//  Created by Benjamin Melville on 10/10/23.
//

import SwiftUI


@MainActor
final class CustomerViewModel: ObservableObject {
    
    
    @Published private(set) var user: Customer? = nil
    @Published var sellers: [Seller]? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        
        self.user = try await CustomerManager.shared.getCustomer(userId: authDataResult.uid)
    }
    
    //TODO: function to fetch all of the seller user data
    func getAllSellers() async throws {
        let sellers: [Seller] = try await SellerManager.shared.getAllSellers()
        self.sellers = sellers
    }
    
}




struct CustomerHomeView: View {
    
    @StateObject private var viewModel = CustomerViewModel()
    
    @State var searchText: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.tan.ignoresSafeArea()
                
                ScrollView {
                    Spacer()
                    HStack(spacing: 25.0) {
                        VStack {
                            Text("🍔")
                                .font(.system(.largeTitle, design: .serif))
                            Text("American")
                        }
                        .frame(width: 80, height: 80)
                        
                        VStack {
                            Text("🍝")
                                .font(.system(.largeTitle, design: .serif))
                            Text("Italian")
                        }
                        .frame(width: 80, height: 80)
                        
                        VStack {
                            Text("🥡")
                                .font(.system(.largeTitle, design: .serif))
                            Text("Chinese")
                        }
                        .frame(width: 80, height: 80)
                        
                        VStack {
                            Text("🌮")
                                .font(.system(.largeTitle, design: .serif))
                            Text("Mexican")
                        }
                        .frame(width: 80, height: 80)
                        
                    }
                    .font(.headline)
                    
                    Divider()
                        .frame(height: 0.5)
                        .overlay(.accent)
                        .padding()
                    
                    if let sellers = viewModel.sellers {
                        
                        ForEach(sellers, id: \.self) { seller in
                            
                            FeedCellView(seller: seller)

                        }
                    }
                }
                .navigationTitle("Cozy Eats")
                .searchable(text: $searchText)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            ShoppingCartView()
                        } label: {
                            Image(systemName: "cart")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundStyle(.black)
                                .overlay(alignment: .topTrailing) {
                                    
                                    if let user = viewModel.user, let cart = user.cart {
                                        Image(systemName: "circle.fill")
                                            .frame(width: 8, height: 8)
                                            .foregroundStyle(.red)
                                            .overlay(
                                                Text("\(cart.count)")
                                                    .foregroundStyle(.white)
                                            )
                                    }
                                }

                        }

                    }
                    
                }
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(Color.accentColor, for: .navigationBar)
            }
        }
        .task {
            try? await viewModel.getAllSellers()
            try? await viewModel.loadCurrentUser()
        }
    }
}

#Preview {
    CustomerHomeView()
}
