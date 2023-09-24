



import UIKit

class CartViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var cartProductImage: UIImageView!
    @IBOutlet weak var cartProductName: UILabel!
    @IBOutlet weak var cartProductPrice: UILabel!
    @IBOutlet weak var productAmountLabel: UILabel!
    @IBOutlet weak var quantityStepper: UIStepper!
    
    // MARK: - Closure for Quantity Change
    
    var quantityChanged: ((Double) -> Void)?
    
    // MARK: - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Add a target-action to the quantity stepper to detect value changes
        quantityStepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
    }

    // MARK: - Stepper Value Changed Action
    
    @objc func stepperValueChanged(_ sender: UIStepper) {
        // Update the product amount label with the stepper value
        productAmountLabel.text = "\(Int(sender.value))"
        
        // Extract the product price and calculate the total price based on quantity
        if let priceText = cartProductPrice.text, let price = Double(priceText.replacingOccurrences(of: " EGP", with: "")) {
            let totalPrice = price * sender.value
            
            // Trigger the quantityChanged closure with the new total price
            quantityChanged?(totalPrice)
        }
    }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
    }
}
