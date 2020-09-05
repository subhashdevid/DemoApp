//
//  MenuCell.swift
//  Paysfer
//
//  Created by VISHAL VERMA on 18/06/20.
//  Copyright © 2020 VISHAL VERMA. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    
    static let reuseId = "MenuCell"
    
    @IBOutlet weak var btnp: UIButton!


    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
