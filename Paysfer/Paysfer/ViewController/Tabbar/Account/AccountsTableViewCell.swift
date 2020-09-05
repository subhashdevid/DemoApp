//
//  AccountsTableViewCell.swift
//  Paysfer
//
//  Created by SUBHASH KUMAR on 02/09/20.
//  Copyright © 2020 VISHAL VERMA. All rights reserved.
//

import UIKit

class AccountsTableViewCell: UITableViewCell {

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var editImageBtn: UIButton!
    @IBOutlet weak var editProfileBtn: UIButton!
    @IBOutlet weak var editAddressBtn: UIButton!
    @IBOutlet weak var contactUsBtn: UIButton!
    @IBOutlet weak var privacyPolicyBtn: UIButton!
    @IBOutlet weak var termsConditionBtn: UIButton!
    @IBOutlet weak var logOutBtn: UIButton!
    
    static let reuseId = "AccountsTableViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
