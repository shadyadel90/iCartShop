


import UIKit

class CartViewController: UITableViewController {
    
    // MARK: - Properties
    
    var viewModel = CartViewModel()
    
    @IBOutlet weak var calculateButton: UIButton!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load cart data from the ViewModel
        viewModel.loadCart()
        
        // Update the total price label
        updateTotalPriceLabel()
        
        // Reload the table view to display cart items
        tableView.reloadData()
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.selectedProducts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartViewCell", for: indexPath) as! CartViewCell
        
        // Configure the cell with data from the ViewModel
        let product = viewModel.selectedProducts[indexPath.row]
        cell.cartProductName.text = product.title
        cell.cartProductPrice.text = "\(product.price) EGP"
        cell.productAmountLabel.text = "1"
        cell.quantityStepper.value = 1
        
        // Closure to handle quantity changes in the cell
        cell.quantityChanged = { [weak self] totalPrice in
            self?.viewModel.totalPrices[indexPath.row] = totalPrice
            self?.updateTotalPriceLabel()
        }
        
        // Load product image asynchronously
        viewModel.loadImageForProduct(at: indexPath) { image in
            if let image = image {
                cell.cartProductImage.image = image
            } else {
                cell.cartProductImage.image = UIImage(named: "pencil")
            }
        }
        
        return cell
    }
    
    // MARK: - Table View Editing
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove the product from the cart and update the UI
            viewModel.removeProduct(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateTotalPriceLabel()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func calulateButtonAction(_ sender: UIButton) {
        // Calculate the total price and display it in an alert
        let totalPriceText = viewModel.calculateTotalPrice()
        if !totalPriceText.isEmpty {
            let okAction = UIAlertAction(title: "OK", style: .default)
            let alert = viewModel.createAlert(title: "Yay!", message: "You have to pay \(totalPriceText) EGP", actions: [okAction])
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func ClearAllButton(_ sender: UIBarButtonItem) {
        // Display an alert to confirm clearing the cart
        let okAction = UIAlertAction(title: "OK", style: .default) { [self] _ in
            viewModel.clearCart()
            updateTotalPriceLabel()
            tableView.reloadData()
        }
        let cancelAcion = UIAlertAction(title: "Cancel", style: .cancel)
        let alert = viewModel.createAlert(title: "Clear the cart?", message: "Are you sure you want to clear all your selected items?", actions: [okAction, cancelAcion])
        present(alert, animated: true)
    }
    
    // MARK: - Helper Methods
    
    // Update total price label displayed on the button
    func updateTotalPriceLabel() {
        let totalPriceText = viewModel.calculateTotalPrice()
        calculateButton.setTitle("Pay (\(totalPriceText))", for: .normal)
    }
}

