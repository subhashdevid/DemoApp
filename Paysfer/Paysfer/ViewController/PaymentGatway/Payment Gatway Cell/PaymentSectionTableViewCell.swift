//
//  PaymentSectionTableViewCell.swift
//  Paysfer
//
//  Created by SUBHASH KUMAR on 23/09/20.
//  Copyright © 2020 VISHAL VERMA. All rights reserved.
//

import UIKit

class PaymentSectionTableViewCell: UITableViewCell {

    @IBOutlet weak var selectedIcon: UIImageView!
    @IBOutlet weak var cellTitleLbl: UILabel!
    @IBOutlet weak var selectSectionBtn: UIButton!
    
    static let reuseId = "PaymentSectionTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
