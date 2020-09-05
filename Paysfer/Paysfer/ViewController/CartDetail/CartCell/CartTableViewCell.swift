//
//  CartTableViewCell.swift
//  Paysfer
//
//  Created by VISHAL VERMA on 10/08/20.
//  Copyright © 2020 VISHAL VERMA. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var pro_title: UILabel!
    @IBOutlet weak var pro_regular_price: UILabel!
    @IBOutlet weak var pro_sale_price: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnSubtractQty: UIButton!
    @IBOutlet weak var btnAddQty: UIButton!
    @IBOutlet weak var lblLine: UILabel!

    
    static let reuseId = "CartTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
