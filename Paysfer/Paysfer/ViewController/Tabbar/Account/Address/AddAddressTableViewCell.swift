//
//  AddAddressTableViewCell.swift
//  Paysfer
//
//  Created by SUBHASH KUMAR on 15/09/20.
//  Copyright © 2020 VISHAL VERMA. All rights reserved.
//

import UIKit

class AddAddressTableViewCell: UITableViewCell {

    @IBOutlet weak var firstNameFld: UITextField!
    @IBOutlet weak var lastNameFld: UITextField!
    @IBOutlet weak var phoneFld: UITextField!
    @IBOutlet weak var hNoCompanyFld: UITextField!
    @IBOutlet weak var addline1Fld: UITextField!
    @IBOutlet weak var addLine2Fld: UITextField!
    @IBOutlet weak var cityFld: UITextField!
    @IBOutlet weak var countryFld: UITextField!
    @IBOutlet weak var stateFld: UITextField!
   
    @IBOutlet weak var zipCodeFld: UITextField!
    
    
     @IBOutlet weak var countryBtn: UIButton!
     @IBOutlet weak var stateBtn: UIButton!
    
    
    @IBOutlet weak var setAsDefaultBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var setAsDefaultImg: UIImageView!
    
    
     static let reuseId = "AddAddressTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
