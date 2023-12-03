//
//  ProfileView.swift
//  CozyEats
//
//  Created by Benjamin Melville on 10/10/23.
//

import SwiftUI

@MainActor
final class CustomerProfileViewModel: ObservableObject {
    
    
    @Published private(set) var user: Customer? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await CustomerManager.shared.getCustomer(userId: authDataResult.uid)
    }
    
    func signOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    
}


struct CustomerProfileView: View {
    
    @StateObject private var viewModel = CustomerProfileViewModel()
    @Binding var showSignInView: Bool

    
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
                    .font(.system(.headline, design: .serif))
                    .fontWeight(.regular)

                    Section {
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
                    CustomerSettingsView()
                        .listRowBackground(Color.tan)

                }
                .scrollContentBackground(.hidden)
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
    CustomerProfileView(showSignInView: .constant(false))
}
