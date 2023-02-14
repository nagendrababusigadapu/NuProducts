//
//  ProductsList.swift
//  NuProducts
//
//  Created by Nagendra Babu on 12/02/23.
//

import Foundation


struct ProductList: Codable {
    let products: [Product]
    let total, skip, limit: Int
}

// MARK: - Product
struct Product: Codable {
    let id: Int?
    let title, description: String?
    let price: Int?
    let discountPercentage, rating: Double?
    let stock: Int?
    let brand, category: String?
    let thumbnail: String?
    let images: [String?]
}
