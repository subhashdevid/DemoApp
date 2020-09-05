//
//  CheckoutTableViewCell.swift
//  Paysfer
//
//  Created by SUBHASH KUMAR on 25/08/20.
//  Copyright © 2020 VISHAL VERMA. All rights reserved.
//

import UIKit

class CheckoutTableViewCell: UITableViewCell {

    static let reuseId = "CheckoutTableViewCell"
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var addressBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
    
}
