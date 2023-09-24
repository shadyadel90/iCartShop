//
//  NetworkManager.swift
//  myproject0
//
//  Created by Shady Adel on 22/09/2023.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() { }
    
    func fetchDataFromAPI(completion: @escaping ([Product]?, Error?) -> Void) {
        guard let url = URL(string: "https://fakestoreapi.com/products") else {
            print("Invalid URL")
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }

        let session = URLSession.shared

        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(nil, error)
                return
            }

            guard let data = data else {
                print("No data received")
                completion(nil, NSError(domain: "No data received", code: 0, userInfo: nil))
                return
            }

            do {
                let products = try JSONDecoder().decode([Product].self, from: data)
                completion(products, nil)
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil, error)
            }
        }

        task.resume()
    }
    
    func loadImage(fromURL imageURL: URL?, completion: @escaping (Data?, Error?) -> Void) {
        guard let imageURL = imageURL else {
            completion(nil, NSError(domain: "Invalid Image URL", code: 0, userInfo: nil))
            return
        }

        let task = URLSession.shared.dataTask(with: imageURL) { data, response, error in
            if let error = error {
                print("Error loading image: \(error)")
                completion(nil, error)
            } else {
                completion(data, nil)
            }
        }

        task.resume()
    }
}
