//
//  ProductViewCell.swift
//  myproject0
//
//  Created by Shady Adel on 24/09/2023.
//

import UIKit

class ProductViewCell: UITableViewCell {

    @IBOutlet weak var ProductImage: UIImageView!
    
    @IBOutlet weak var ProductName: UILabel!
    
    @IBOutlet weak var ProductPrice: UILabel!
    
    @IBOutlet weak var AddProduct: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


}
