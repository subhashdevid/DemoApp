//
//  sectionHeaderTableViewCell.swift
//  Paysfer
//
//  Created by SUBHASH KUMAR on 25/08/20.
//  Copyright © 2020 VISHAL VERMA. All rights reserved.
//

import UIKit

class sectionHeaderTableViewCell: UITableViewCell {

      @IBOutlet weak var cellTitleLbl: UILabel!
      @IBOutlet weak var cellButton: UIButton!
    
    static let reuseId = "sectionHeaderTableViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
