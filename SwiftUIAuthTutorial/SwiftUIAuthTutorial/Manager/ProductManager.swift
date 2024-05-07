//
//  ProductManager.swift
//  SwiftUIAuthTutorial
//
//  Created by Anh Dinh on 5/6/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class ProductManager {
    static let shared = ProductManager()
    private init() {
        
    }
    
    let productCollectionPath = Firestore.firestore().collection("products")
    
    // upload a product to FireStore
    func uploadProductsToFireStore(_ product: Product) async throws {
        do {
            try productCollectionPath.document(String(product.id)).setData(from: product)
        } catch {
            print("DEBUG ERROR UPLOADING PRODUCTS: \(error.localizedDescription)")
        }
    }
    
    // get all products documents
    func getAllProduct() async throws -> [Product] {
        var productsArray: [Product] = []
        do {
            // Get all documents in the collection
            let snapshot = try await productCollectionPath.getDocuments()
            for product in snapshot.documents {
                // cast each product into Product type
                // then append to array
                try productsArray.append(product.data(as: Product.self))
            }
        } catch {
            print("DEBUG ERROR GETTING ALL PRODUCT DOCUMENTS: \(error.localizedDescription)")
        }
        return productsArray
    }
    
    func getAllProductsByUsingGeneric() async throws -> [Product] {
        return try await productCollectionPath.getAllDocumentsShortForm(as: Product.self)
    }
}

extension Query {
    /// Generic func to download all documents in Firestore
    /// when we use 'self' => it's collection path.
    /// For example, Firestore.firestore().collection("products") = Query
    func getAllDocuments<T: Decodable>(as type: T.Type) async throws -> [T] {
        var productsArray: [T] = []
        // Get all documents in the collection
        let snapshot = try await self.getDocuments()
        for product in snapshot.documents {
            // cast each product into T type
            try productsArray.append(product.data(as: T.self))
        }
        return productsArray
    }
    
    func getAllDocumentsShortForm<T: Decodable>(as type: T.Type) async throws -> [T] {
        let snapshot = try await self.getDocuments()
        // Create an array with .map
        return try snapshot.documents.map { document in
            // With each document in snapshot.documents array
            // cast it to T Type
            // so we can have an array of T Type out of snapshot.documents array
            return try document.data(as: T.self)
        }
    }
}
