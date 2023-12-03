//
//  SignInWithEmailViewModel.swift
//  CozyEats
//
//  Created by Benjamin Melville on 10/14/23.
//

import Foundation

@MainActor
final class SignInWithEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func signIn() async throws -> String {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found.")
            return ""
        }
        let authDataResult = try await AuthenticationManager.shared.signInUser(email: email, password: password)
        var userType = ""
        
        do {
            let seller = try await SellerManager.shared.getSeller(userId: authDataResult.uid)
            userType = "seller"
            print(seller)
            return userType
            
        } catch {
            let customer = try await CustomerManager.shared.getCustomer(userId: authDataResult.uid)
            userType = "customer"
            print(customer)
            return userType
        }

    }
    
}
