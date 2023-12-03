//
//  StorageManager.swift
//  CozyEats
//
//  Created by Benjamin Melville on 10/16/23.
//

import Foundation
import FirebaseStorage
import SwiftUI

final class StorageManager {
    
    static let shared = StorageManager()
    private init() { }
    
    private let storage = Storage.storage().reference()
    
    
    func saveImage(userId: String, menuItemName: String, data: Data) async throws -> String {
        
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        let path = "\(userId)/\(menuItemName)/\(UUID().uuidString).jpeg"
                
        let _ = try await storage.child(path).putDataAsync(data, metadata: meta)
            
        return path     
        
    }
    
    func getImage(imageUrl: String) async throws -> Data {
//        print("getting image now...")
        do {
            let data = try await storage.child(imageUrl).data(maxSize: 20 * 1024 * 1024)
            return data
        } catch {
            print(error)
            return Data()
        }
    }
    
}
