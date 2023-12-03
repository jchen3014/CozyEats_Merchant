//
//  UserManager.swift
//  CozyEats
//
//  Created by Benjamin Melville on 10/15/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift



struct Customer: Codable {
    let firstName: String?
    let lastName: String?
    let userId: String
    let dateCreated : Date?
    let email: String?
    let photoUrl: String?
    var cart: [MenuItem]?
    
    init(auth: AuthDataResultModel, firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.userId = auth.uid
        self.dateCreated = Date()
        self.email = auth.email
        self.photoUrl = auth.photoUrl
        self.cart = nil
    }
    
    init(
        firstName: String?,
        lastName: String?,
        userId: String,
        dateCreated : Date?,
        email: String?,
        photoUrl: String?,
        cart: [MenuItem]?
    ) {
        self.firstName = firstName
        self.lastName = lastName
        self.userId = userId
        self.dateCreated = dateCreated
        self.email = email
        self.photoUrl = photoUrl
        self.cart = cart
        
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.firstName, forKey: .firstName)
        try container.encodeIfPresent(self.lastName, forKey: .lastName)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
        try container.encodeIfPresent(self.cart, forKey: .cart)
    }
    
    enum CodingKeys: String, CodingKey {
        case firstName
        case lastName
        case userId
        case dateCreated
        case email
        case photoUrl
        case cart = "cart"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.cart = try container.decodeIfPresent([MenuItem].self, forKey: .cart)
    }
    
}

final class CustomerManager {
    static let shared = CustomerManager()
    
    private init() { }
    
    private let customerCollection = Firestore.firestore().collection("customers")
    
    private func customerDocument(userId: String) -> DocumentReference {
        return customerCollection.document(userId)
    }
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        return encoder
    }()
    
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        return decoder
    }()
    
    func createNewCustomer(user: Customer) async throws {
        try customerDocument(userId: user.userId).setData(from: user, merge: false)
    }
    
    
    func getCustomer(userId: String) async throws -> Customer {
        return try await customerDocument(userId: userId).getDocument(as: Customer.self)
    }
    
    func addToCart(userId: String, menuItem: MenuItem, quantity: Int) async throws {
        
        
        guard let data = try? encoder.encode(menuItem) else {
            throw URLError(.badURL)
        }
        
        let dict: [String : Any] = [
        
            Customer.CodingKeys.cart.stringValue : FieldValue.arrayUnion([data])
        
        ]
        
        try await customerDocument(userId: userId).updateData(dict)
    }
}
