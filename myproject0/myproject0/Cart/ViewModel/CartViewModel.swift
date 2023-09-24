//
//  CartViewModel.swift
//  myproject0
//
//  Created by Shady Adel on 23/09/2023.
//

import Foundation
import UIKit

class CartViewModel {
    
    // MARK: - Properties
    
    var selectedProducts: [Product] = []  // Array to store selected products
    var totalPrices: [Double] = []        // Array to store total prices
    
    // MARK: - Cart Operations
    
    // Load cart items from local storage and update total prices
    func loadCart() {
        selectedProducts = LocalStorageManager.retrieveProductsFromLocalStorage()
        updateTotalPrice()
    }
    
    // Clear the entire cart
    func clearCart() {
        selectedProducts = []
        totalPrices = []
        updateTotalPrice()
        LocalStorageManager.saveProductsToLocalStorage(selectedProducts)
    }
    
    // Remove a product from the cart at a specific index
    func removeProduct(at index: Int) {
        selectedProducts.remove(at: index)
        totalPrices.remove(at: index)
        LocalStorageManager.saveProductsToLocalStorage(selectedProducts)
        updateTotalPrice()
    }
    
    // Calculate the total price of all selected products and return it as a string
    func calculateTotalPrice() -> String {
        let totalPrice = Int(ceil(totalPrices.reduce(0, +)))
        return "\(totalPrice)"
    }
    
    // Update the totalPrices array with the prices of selected products
    private func updateTotalPrice() {
        totalPrices = selectedProducts.map { $0.price }
    }
    
    // MARK: - Image Loading
    
    // Load an image for a product asynchronously and call the completion handler
    func loadImageForProduct(at indexPath: IndexPath, completion: @escaping (UIImage?) -> Void) {
        let product = selectedProducts[indexPath.row]
        if let imageURL = URL(string: product.image) {
            NetworkManager.shared.loadImage(fromURL: imageURL) { data, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completion(image)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
        } else {
            completion(nil)
        }
    }
    
    // MARK: - Alert Creation
    
    // Create and return a UIAlertController with a title, message, and an array of UIAlertAction
    func createAlert(title: String, message: String, actions: [UIAlertAction]) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alert.addAction(action)
        }
        return alert
    }
}
