//
//  SellerHomeView.swift
//  CozyEats
//
//  Created by Benjamin Melville on 10/16/23.
//

import SwiftUI


@MainActor
final class SellerViewModel: ObservableObject {
    
    @Published private(set) var user: Seller? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await SellerManager.shared.getSeller(userId: authDataResult.uid)
    }
    
    
}

struct SellerHomeView: View {
    
    @StateObject private var viewModel = SellerViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.tan
                ScrollView {
                    if let user = viewModel.user {
                        if let menu = user.menu {
                            ForEach(menu) { menuItem in
                                MenuItemCardView(menu: menuItem)
                                Divider()
                }
                        }
                    }
                }
                
            }
            .navigationTitle("Cozy Eats")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        AddMenuItemView()
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(Color.primary)
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color.accentColor, for: .navigationBar)
        }
        .task {
            try? await viewModel.loadCurrentUser()
        }
    }
}

#Preview {
    SellerHomeView()
}
