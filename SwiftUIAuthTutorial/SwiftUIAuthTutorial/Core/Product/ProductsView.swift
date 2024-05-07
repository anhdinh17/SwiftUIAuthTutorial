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
    @Published var selectedFilter: FilterOption = .none // First get to the screen, this should be none
    @Published var selectedCategory: CategoryOption = .none
    
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
    
    enum FilterOption: String, CaseIterable {
        case none
        case priceHigh
        case priceLow
    }
    
    func filterSelected(option: FilterOption) async throws {
        switch option {
        case .none:
            self.products = try await ProductManager.shared.getAllProductsByUsingGeneric()
        case .priceHigh:
            // Get the sorted documents
            self.products = try await ProductManager.shared.getAllProductsSortedByPrice(isDescending: true)
        case .priceLow:
            self.products = try await ProductManager.shared.getAllProductsSortedByPrice(isDescending: false)
        }
        // Keep track of selected filter
        self.selectedFilter = option
    }
    
    enum CategoryOption: String, CaseIterable {
        case none
        case smartphones
        case laptops
        case fragrances
    }
    
    func categorySelected(option: CategoryOption) async throws {
        switch option {
        case .none:
            self.products = try await ProductManager.shared.getAllProductsByUsingGeneric()
        case .smartphones, .laptops, .fragrances:
            self.products = try await ProductManager.shared.getAllProductsForCategory(category: option.rawValue)
        }
        // Keep track of selected filter
        self.selectedCategory = option
    }
    
}

struct ProductsView: View {
    @StateObject private var viewModel = ProductsViewModel()
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.products){ product in
                    ProductCellView(product: product)
                }
            }
            .navigationTitle("Products")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu("Filter: \(viewModel.selectedFilter.rawValue)") {
                        // Loop through enum cases to create button regarding the case
                        ForEach(ProductsViewModel.FilterOption.allCases, id: \.self){ eachCase in
                            Button(eachCase.rawValue){
                                // Click on each button will
                                // trigger filterSelected() with case respectively.
                                Task {
                                    try await viewModel.filterSelected(option: eachCase)
                                }
                            }
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("Category: \(viewModel.selectedCategory.rawValue)") {
                        ForEach(ProductsViewModel.CategoryOption.allCases, id: \.self){ eachCase in
                            Button(eachCase.rawValue){
                                Task {
                                    try await viewModel.categorySelected(option: eachCase)
                                }
                            }
                        }
                    }
                }
            }
            .task {
                try? await viewModel.getAllProducts()
            }
        }
    }
}

#Preview {
    ProductsView()
}
