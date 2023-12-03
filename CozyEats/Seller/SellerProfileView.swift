//
//  SellerProfileview.swift
//  CozyEats
//
//  Created by Benjamin Melville on 10/16/23.
//

import SwiftUI

@MainActor
final class SellerProfileViewModel: ObservableObject {
    
    @Published private(set) var user: Seller? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await SellerManager.shared.getSeller(userId: authDataResult.uid)
    }
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
}


struct SellerProfileView: View {
    
    @Binding var showSignInView: Bool
    @StateObject var viewModel = SellerProfileViewModel()
    
    var body: some View {
        NavigationStack {
            if let user = viewModel.user {
                List {
                    
                    Group {
                        Text("\(user.firstName ?? "") \(user.lastName ?? "")")
                        Text("\(user.userId)")
                        Text("\(user.dateCreated?.description ?? "")")
                        Text("\(user.email ?? "")")
                    }
                    
                    Section {
                        logOutSection
                    }
                }
                .scrollContentBackground(.hidden)
                .listRowBackground(Color.red)
                .background(Color.tan)
                .navigationTitle("\(user.firstName ?? "")'s Profile")
            }
            
        }
        .task {
            try? await viewModel.loadCurrentUser()
        }
    }
}

#Preview {
    SellerProfileView(showSignInView: .constant(false))
}


extension SellerProfileView {
    private var logOutSection: some View {
        Button {
            Task {
                do {
                    try viewModel.signOut()
                    withAnimation {
                        showSignInView = true
                    }
                } catch {
                    print(error)
                }
            }

        } label: {
            Text("Logout")
                .foregroundStyle(Color.red)
        }
    }
    
}
