//
//  ProductListView.swift
//  myproject0
//
//  Created by Shady Adel on 24/09/2023.
//

import UIKit

class ProductListView: UITableViewController {
    
    // MARK: - Properties
    
    var viewModel = ProductViewModel()

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePullToRefresh()
        fetchDataAndUpdateUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.retriveFromLocalStorage()
        tableView.reloadData()
    }

    // MARK: - Pull-to-Refresh Setup
    
    func configurePullToRefresh() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }

    // MARK: - Pull-to-Refresh Action
    
    @objc func didPullToRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Clear the products array and refresh data
            self.viewModel.products = []
            self.fetchDataAndUpdateUI()
            self.tableView.reloadData()
            
            // End refreshing state
            self.refreshControl?.endRefreshing()
        }
    }

    // MARK: - Data Fetching and UI Update
    
    func fetchDataAndUpdateUI() {
        viewModel.fetchDataFromAPI {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductViewCell", for: indexPath) as! ProductViewCell
        
        let product = viewModel.products[indexPath.row]

        // Configure cell with product data
        cell.ProductName.text = product.title
        cell.ProductPrice.text = "\(product.price) EGP"
        
        viewModel.loadImageForProduct(at: indexPath) { image in
            if let image = image {
                cell.ProductImage.image = image
            } else {
                cell.ProductImage.image = UIImage(named: "pencil")
            }
        }

        cell.AddProduct.tag = indexPath.row
        cell.AddProduct.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
        
        // Update button title based on cart state
        if viewModel.isProductAddedToCart(at: indexPath.row) {
            cell.AddProduct.setTitle("Added", for: .normal)
        } else {
            cell.AddProduct.setTitle("Add in Cart", for: .normal)
        }
        
        return cell
    }

    // MARK: - Add to Cart Action
    
    @objc func addToCart(sender: UIButton) {
        let rowIndex: Int = sender.tag
        viewModel.addToCart(at: rowIndex)
        tableView.reloadData()
    }
}

