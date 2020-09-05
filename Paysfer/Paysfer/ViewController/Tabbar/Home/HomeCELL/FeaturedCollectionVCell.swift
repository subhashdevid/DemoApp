//
//  FeaturedCollectionVCell.swift
//  Paysfer
//
//  Created by VISHAL VERMA on 22/06/20.
//  Copyright © 2020 VISHAL VERMA. All rights reserved.
//

import UIKit

class FeaturedCollectionVCell: UICollectionViewCell {
    
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var lblFinalPrice: UILabel!
    @IBOutlet weak var lblSelingPrice: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    
    @IBOutlet weak var lblLine: UILabel!

    @IBOutlet weak var lblDiscount: UILabel!
     @IBOutlet var vwImageBg: UIView!
    @IBOutlet var vwBackground: UIView!
    @IBOutlet var vwBottomBg: UIView!
    @IBOutlet weak var btnHeart: UIButton!
    @IBOutlet weak var imgHeart: UIImageView!
    @IBOutlet weak var gotoDetail: UIButton!

    @IBOutlet weak var btnAddToCart: UIButton!



        
    static let reuseId = "FeaturedCollectionVCell"

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        vwImageBg.layer.masksToBounds = true
    }
}
