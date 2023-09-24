//
//  Product.swift
//  myproject0
//
//  Created by Shady Adel on 21/09/2023.
//

import Foundation

struct Product: Codable, Equatable , Hashable {
    
    let title: String
    let price: Double
    let image: String
}
