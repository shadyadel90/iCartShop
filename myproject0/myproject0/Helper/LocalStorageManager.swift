//
//  LocalStorageManager.swift
//  myproject0
//
//  Created by Shady Adel on 22/09/2023.
//

import Foundation

struct LocalStorageManager {
    
    static let userSelectedProductsKey = "userSelectedProducts"

    static func saveProductsToLocalStorage(_ products: [Product]) {
        if let encoded = try? JSONEncoder().encode(products) {
            UserDefaults.standard.set(encoded, forKey: userSelectedProductsKey)
        }
    }

    static func retrieveProductsFromLocalStorage() -> [Product] {
        if let data = UserDefaults.standard.object(forKey: userSelectedProductsKey) as? Data,
           let selectedProducts = try? JSONDecoder().decode([Product].self, from: data) {
            return selectedProducts
        }
        return []
    }
}
