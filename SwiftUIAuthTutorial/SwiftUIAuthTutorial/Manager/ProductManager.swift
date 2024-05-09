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
    
    func getAllProductsSortedByPrice(isDescending: Bool) async throws -> [Product]{
        // .order is handled by Firestore,
        // it will sort the documents based on the field we set, i.e "price"
        // then we use the Generice .getAllDocuments to get all documents @ the collection path.
        return try await productCollectionPath.order(by: Product.CodingKeys.price.rawValue, descending: isDescending).getAllDocuments(as: Product.self)
    }
    
    func getAllProductsForCategory(category: String) async throws -> [Product]{
        // Firestore filter the documents based on the field we want
        // In this case, the field is "category".
        // We want to filter the category that is equal to what we select
        return try await productCollectionPath.whereField(Product.CodingKeys.category.rawValue, isEqualTo: category).getAllDocuments(as: Product.self)
    }
}

extension Query {
    /// Generic func to download all documents in Firestore
    /// when we use 'self' => it's 1 collection path.
    /// For example, Firestore.firestore().collection("products") = Query
    ///  => self = Firestore.firestore().collection("products")
    func getAllDocuments<T: Decodable>(as type: T.Type) async throws -> [T] {
        var productsArray: [T] = []
        // Get all documents at the specific collection
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
