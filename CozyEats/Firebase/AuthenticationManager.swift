//
//  AuthenticationManager.swift
//  CozyEats
//
//  Created by Benjamin Melville on 10/15/23.
//
import Foundation
import FirebaseAuth


// Singleton class
final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    
    private init() { }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    
    @discardableResult
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    @discardableResult
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        print("email: \(email)")
        print("password: \(password)")
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        print("the auth result: \(authDataResult)")
        return AuthDataResultModel(user: authDataResult.user)
    }
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return AuthDataResultModel(user: user)
    }
    
    
}
