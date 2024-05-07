//
//  ProductsVie.swift
//  SwiftUIAuthTutorial
//
//  Created by Anh Dinh on 5/6/24.
//

import SwiftUI

enum ErrorNetworking: Error {
    case invalidURL
    case invalidData
    case invalidResponse
    case unknown(Error)
}

@MainActor
final class ProductsViewModel: ObservableObject {
    @Published var products: [Product] = []
    
    /// This func used only once to network data from server and push to DB
    /// We don't need it after that.
    func downloadProductsAndUploadToFirebase() async throws {
        do {
            guard let url = URL(string: "https://dummyjson.com/products") else {
                throw ErrorNetworking.invalidURL
            }
            let (data,response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                throw ErrorNetworking.invalidResponse
            }
            guard let product = try? JSONDecoder().decode(ProductArray.self, from: data) else {
                throw ErrorNetworking.invalidData
            }
            print("NUMBER OF PRODUCTS: \(product.products.count)")
            
            // Upload to Firestore
            let products = product.products
            for eachProduct in products {
                // Use Manager to upload
                try await ProductManager.shared.uploadProductsToFireStore(eachProduct)
            }
        } catch ErrorNetworking.invalidURL {
            print("DEBUG: INVALID URL")
        } catch ErrorNetworking.invalidData {
            print("DEBUG: INVALID DATA")
        } catch ErrorNetworking.invalidResponse {
            print("DEBUG: INVALID RESPONSE")
        } catch {
            print("DEBUG: \(error.localizedDescription)")
        }
    }
    
    func getAllProducts() async throws {
//        do {
//            self.products = try await ProductManager.shared.getAllProduct()
//        } catch {
//            print("DEBUG ERROR FETCHING PRODUCTS ON SCREEN: \(error.localizedDescription)")
//        }
        self.products = try await ProductManager.shared.getAllProductsByUsingGeneric()
    }
}

struct ProductsView: View {
    @StateObject private var viewModel = ProductsViewModel()
    var body: some View {
        List {
            ForEach(viewModel.products){ product in
                ProductCellView(product: product)
            }
        }
        .task {
            try? await viewModel.getAllProducts()
        }
    }
}

#Preview {
    ProductsView()
}
