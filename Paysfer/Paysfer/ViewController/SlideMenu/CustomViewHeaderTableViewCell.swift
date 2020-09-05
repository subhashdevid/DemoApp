//
//  CustomViewHeaderTableViewCell.swift
//  Paysfer
//
//  Created by SUBHASH KUMAR on 05/09/20.
//  Copyright © 2020 VISHAL VERMA. All rights reserved.
//

import UIKit

class CustomViewHeaderTableViewCell: UITableViewCell {

     @IBOutlet weak var cellLabel: UILabel!
     @IBOutlet weak var cellButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
