//
//  ProductCellView.swift
//  SwiftUIAuthTutorial
//
//  Created by Anh Dinh on 5/6/24.
//

import SwiftUI

struct ProductCellView: View {
    let product: Product
    
    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: URL(string: product.thumbnail ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 75, height: 75)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .shadow(radius: 3)
            } placeholder: {
                ProgressView()
            }

            VStack(alignment: .leading) {
                Text(product.title ?? "N/A")
                    .font(.headline)
                    .fontWeight(.bold)
                Text("Price: $" + String(product.price ?? 0))
                Text("Rating: " + String(product.rating ?? 0))
                Text("Category: " + (product.category ?? ""))
                Text("Brand: " + (product.brand ?? ""))
            }
            .font(.callout)
        }
    }
}

#Preview {
    ProductCellView(product: ProductDatabase.products[1])
}
