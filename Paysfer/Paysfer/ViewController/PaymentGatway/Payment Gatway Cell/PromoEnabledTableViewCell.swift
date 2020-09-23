//
//  PromoEnabledTableViewCell.swift
//  Paysfer
//
//  Created by SUBHASH KUMAR on 23/09/20.
//  Copyright © 2020 VISHAL VERMA. All rights reserved.
//

import UIKit

class PromoEnabledTableViewCell: UITableViewCell {

    @IBOutlet weak var promoLabel: UILabel!
    
    
    static let reuseId = "PromoEnabledTableViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
