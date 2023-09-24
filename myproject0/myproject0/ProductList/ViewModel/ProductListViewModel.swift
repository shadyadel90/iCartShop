//
//  ProductListViewModel.swift
//  myproject0
//
//  Created by Shady Adel on 24/09/2023.
//

import Foundation
import UIKit

class ProductViewModel {
    
    // MARK: - Properties
    
    var products: [Product] = [] // All products fetched from the API
    var userSelectedProducts: [Product] = [] // Products selected by the user (added to the cart)
    
    // MARK: - Data Fetching
    
    // Fetch product data from the API
    func fetchDataFromAPI(completion: @escaping () -> Void) {
        NetworkManager.shared.fetchDataFromAPI { [weak self] products, error in
            if let products = products {
                self?.products = products // Update the products array
            }
            completion()
        }
    }
    
    // Load product images asynchronously
    func loadImageForProduct(at indexPath: IndexPath, completion: @escaping (UIImage?) -> Void) {
        let product = products[indexPath.row]
        if let imageURL = URL(string: product.image) {
            NetworkManager.shared.loadImage(fromURL: imageURL) { data, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completion(image) // Return the loaded image
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil) // Unable to load the image
                    }
                }
            }
        } else {
            completion(nil) // Invalid image URL
        }
    }
    
    // MARK: - Cart Management
    
    // Add a product to the user's cart
    func addToCart(at index: Int) {
        if !userSelectedProducts.contains(products[index]) {
            userSelectedProducts.append(products[index])
            LocalStorageManager.saveProductsToLocalStorage(userSelectedProducts) // Save cart to local storage
        }
    }
    
    // Check if a product is added to the user's cart
    func isProductAddedToCart(at index: Int) -> Bool {
        return userSelectedProducts.contains(products[index])
    }
    
    // Retrieve user's cart from local storage
    func retriveFromLocalStorage() {
        userSelectedProducts = LocalStorageManager.retrieveProductsFromLocalStorage()
    }
}

