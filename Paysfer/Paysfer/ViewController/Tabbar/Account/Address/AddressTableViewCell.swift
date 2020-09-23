//
//  AddressTableViewCell.swift
//  Paysfer
//
//  Created by SUBHASH KUMAR on 25/08/20.
//  Copyright © 2020 VISHAL VERMA. All rights reserved.
//

import UIKit

class AddressTableViewCell: UITableViewCell {

    @IBOutlet weak var cellNamelbl : UILabel!
    @IBOutlet weak var cellMobileLbl : UILabel!
    @IBOutlet weak var cellAddress1lbl : UILabel!
    @IBOutlet weak var cellAddress2lbl : UILabel!
    @IBOutlet weak var cellCityLbl : UILabel!
    @IBOutlet weak var cellCountryLbl : UILabel!
    @IBOutlet weak var cellBtn : UIButton!
    
    static let reuseId = "AddressTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
