//
//  CardDetailTableViewCell.swift
//  Paysfer
//
//  Created by SUBHASH KUMAR on 23/09/20.
//  Copyright © 2020 VISHAL VERMA. All rights reserved.
//

import UIKit

class CardDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var cardNumberFLD: UITextField!
    @IBOutlet weak var expiryDateFLD: UITextField!
    @IBOutlet weak var CVVFld: UITextField!
    
    static let reuseId = "CardDetailTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
