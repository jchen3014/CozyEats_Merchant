//
//  SellerManager.swift
//  CozyEats
//
//  Created by Benjamin Melville on 10/15/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift



struct MenuItem: Codable, Identifiable, Hashable {
    let id: String = UUID().uuidString
    let name: String
    let images: [String]
    let price: Int?
    let dietaryRestrictions: [String]?
    let description: String?
    let cuisine: String?
    var quantity: Int?
    var seller: Seller?
    var date: Date?
    
    
    init(name: String, price: Int, description: String, cuisine: String, images: [String], seller: Seller) {
        self.name = name
        self.images = images
        self.price = price
        self.dietaryRestrictions = []
        self.description = description
        self.cuisine = cuisine
        self.quantity = nil
        self.seller = seller
        self.date = Date()
    }
    
    
    enum CodingKeys: CodingKey {
        case name
        case images
        case price
        case dietaryRestrictions
        case description
        case cuisine
        case quantity
        case seller
        case date
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.images = try container.decode([String].self, forKey: .images)
        self.price = try container.decodeIfPresent(Int.self, forKey: .price)
        self.dietaryRestrictions = try container.decodeIfPresent([String].self, forKey: .dietaryRestrictions)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.cuisine = try container.decodeIfPresent(String.self, forKey: .cuisine)
        self.quantity = try container.decodeIfPresent(Int.self, forKey: .quantity)
        self.seller = try container.decodeIfPresent(Seller.self, forKey: .seller)
        self.date = try container.decodeIfPresent(Date.self, forKey: .date)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encodeIfPresent(self.images, forKey: .images)
        try container.encodeIfPresent(self.price, forKey: .price)
        try container.encodeIfPresent(self.dietaryRestrictions, forKey: .dietaryRestrictions)
        try container.encodeIfPresent(self.description, forKey: .description)
        try container.encodeIfPresent(self.cuisine, forKey: .cuisine)
        try container.encodeIfPresent(self.quantity, forKey: .quantity)
        try container.encodeIfPresent(self.seller, forKey: .seller)
        try container.encodeIfPresent(self.date, forKey: .date)
    }
    
    
}

struct Seller: Codable, Hashable {
    let firstName: String?
    let lastName: String?
    let userId: String
    let dateCreated : Date?
    let email: String?
    let photoUrl: String?
    let menu: [MenuItem]?
    let soldItems: [MenuItem]?
    
    init(auth: AuthDataResultModel, firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.userId = auth.uid
        self.dateCreated = Date()
        self.email = auth.email
        self.photoUrl = auth.photoUrl
        self.menu = []
        self.soldItems = []
    }
    
    init(
        firstName: String?,
        lastName: String?,
        userId: String,
        dateCreated : Date?,
        email: String?,
        photoUrl: String?,
        menu: [MenuItem]?,
        soldItems: [MenuItem]?
    ) {
        self.firstName = firstName
        self.lastName = lastName
        self.userId = userId
        self.dateCreated = dateCreated
        self.email = email
        self.photoUrl = photoUrl
        self.menu = menu
        self.soldItems = soldItems
    }
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case userId = "user_id"
        case dateCreated = "date_created"
        case email = "email"
        case photoUrl = "photo_url"
        case menu = "menu"
        case soldItems = "sold_items"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName)
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.menu = try container.decodeIfPresent([MenuItem].self, forKey: .menu)
        self.soldItems = try container.decodeIfPresent([MenuItem].self, forKey: .soldItems)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.firstName, forKey: .firstName)
        try container.encodeIfPresent(self.lastName, forKey: .lastName)
        try container.encode(self.userId, forKey: .userId)
        try container.encodeIfPresent(self.dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(self.email, forKey: .email)
        try container.encodeIfPresent(self.photoUrl, forKey: .photoUrl)
        try container.encodeIfPresent(self.menu, forKey: .menu)
        try container.encodeIfPresent(self.soldItems, forKey: .soldItems)
    }
}




final class SellerManager {
    static let shared = SellerManager()
    
    private init() { }
    
    private let sellerCollection = Firestore.firestore().collection("sellers")
    
    private func sellerDocument(userId: String) -> DocumentReference {
        return sellerCollection.document(userId)
    }
    
    
    
    private let encoder: Firestore.Encoder = {
        let encoder = Firestore.Encoder()
        return encoder
    }()
    
    private let decoder: Firestore.Decoder = {
        let decoder = Firestore.Decoder()
        return decoder
    }()
    
    func createNewSeller(user: Seller) async throws {
        try sellerDocument(userId: user.userId).setData(from: user, merge: false)
    }
    
    
    func getSeller(userId: String) async throws -> Seller {
        return try await sellerDocument(userId: userId).getDocument(as: Seller.self)
    }
    
    func addMenuItem(userId: String, menuItem: MenuItem) async throws {
        guard let data = try? encoder.encode(menuItem) else {
            throw URLError(.badURL)
        }
        
        let dict: [String:Any] = [
            
            Seller.CodingKeys.menu.rawValue : FieldValue.arrayUnion([data])
        
        ]
        
        try await sellerDocument(userId: userId).updateData(dict)
        
    }
    
    func getAllSellers() async throws -> [Seller] {
        let snapshot = try await sellerCollection.getDocuments()
        
        var sellers: [Seller] = []
        
        for document in snapshot.documents {
            let seller = try document.data(as: Seller.self)
            sellers.append(seller)
        }
        print(sellers.description)
        
        
        return sellers
    }
    
    func updateMenuItemTime(menuItem: MenuItem) async throws -> MenuItem {
        var updatedMenuItem = MenuItem(name: menuItem.name, price: menuItem.price ?? 0, description: menuItem.description ?? "", cuisine: menuItem.cuisine ?? "", images: menuItem.images, seller: menuItem.seller!)
        
        updatedMenuItem.date = Date()
        updatedMenuItem.quantity = menuItem.quantity
        
        return updatedMenuItem
    }
    
    
    func addToSoldItems(menuItem: MenuItem) async throws {
        
        guard let seller = menuItem.seller else { return }
        
        var newMenuItem = try await updateMenuItemTime(menuItem: menuItem)
        
        guard let data = try? encoder.encode(newMenuItem) else {
            throw URLError(.badURL)
        }
        
        let dict: [String:Any] = [
        
            Seller.CodingKeys.soldItems.rawValue : FieldValue.arrayUnion([data])
        
        ]
        
        try await sellerDocument(userId: seller.userId).updateData(dict)
        
    }
    
    
    
    
}
