//
//  FeaturedCell.swift
//  Paysfer
//
//  Created by VISHAL VERMA on 22/06/20.
//  Copyright © 2020 VISHAL VERMA. All rights reserved.
//

import UIKit
import PKHUD

protocol CategoryRowDelegate:class {
func cellTapped()
}


class FeaturedCell: UITableViewCell {
    
    static let reuseId = "FeaturedCell"
    
    @IBOutlet weak var collectionViewFeatured: UICollectionView!
    @IBOutlet weak var lblHeading: UILabel!
    var featureData = [FeatureModel]()
    var newArrival = [NewArrivalModel]()
    var wishCount = String()
    let service = ServerHandler()
    weak var delegate:CategoryRowDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerNibFiles()
        homeProductData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    private func registerNibFiles(){
        self.collectionViewFeatured.register(UINib.init(nibName: "FeaturedCollectionVCell", bundle: nil), forCellWithReuseIdentifier: FeaturedCollectionVCell.reuseId)
        
    }
    
    
    func homeProductData(){
        
        let userData = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
        HUD.show(.labeledProgress(title: "", subtitle: "Getting products for you..."))
        
        service.getResponseFromServer(parametrs: "home_product.php?home_product=home_product&&user_id=\( userData.user_id ?? "")") { (results) in
            let status = results["status"] as? String ?? ""
            if status == "1"{
                HUD.hide()
                let count = results["wish_count"] as? String ?? ""
                
                UserDefaults.standard.set(count, forKey: "wishC")
                
                if let quets = results["data"] as? [String:Any]{
                    if let feature = quets["feature_product"] as? [[String:Any]]{
                        for item in feature{
                            print(item)
                            self.featureData.append(FeatureModel(item))
                        }
                    }
                    if let feature = quets["new_arrival"] as? [[String:Any]]{
                        for item in feature{
                            print(item)
                            self.newArrival.append(NewArrivalModel(item))
                        }
                    }
                    DispatchQueue.main.async {
                        self.collectionViewFeatured.reloadData()
                    }
                    //
                    //                    self.pgControl.numberOfPages = self.imageData.count
                }
            }else{
                
                
                Helper.showSnackBar(with: results["message"] as? String ?? "")
                //                let alertController = UIAlertController(title: "Failure", message: results["message"] as? String ?? "", preferredStyle: .alert)
                //
                //                let cancelAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel) {
                //                    UIAlertAction in
                //                }
                //                alertController.addAction(cancelAction)
                
            }
        }
    }
    
    
    
    
}
extension FeaturedCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if lblHeading.text == "New Arrial"{
            return newArrival.count
        }
        else{
            return featureData.count
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedCollectionVCell", for: indexPath) as! FeaturedCollectionVCell
        
        cell.vwBackground.layer.shadowColor = UIColor.black.cgColor
        cell.vwBackground.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        cell.vwBackground.layer.shadowRadius = 5
        cell.vwBackground.layer.shadowOpacity = 0.3
        cell.vwBackground.layer.cornerRadius = 8
        cell.vwBottomBg.roundedView()
        cell.imgBackground.roundedimgView()
        
        if lblHeading.text == "New Arrial"{
            let newArriv = newArrival[indexPath.row]
            cell.lblProductName.text = newArriv.pro_title
            
            if let discount = newArriv.pro_discount{
                
                
                if discount == "0" {
                    if let price = newArriv.pro_regular_price{
                        cell.lblFinalPrice.text = "$ \(price)"
                    }
                    
                    
                    cell.lblSelingPrice.isHidden = true
                    cell.lblLine.isHidden = true
                    cell.lblDiscount.isHidden = true
                }
                else{
                    if let price = newArriv.pro_sale_price{
                        cell.lblFinalPrice.text = "$ \(price)"
                    }
                    
                    
                    cell.lblSelingPrice.isHidden = false
                    cell.lblLine.isHidden = false
                    cell.lblDiscount.isHidden = false
                    cell.lblDiscount.text = "\(discount)% OFF"
                    
                    if let price = newArriv.pro_regular_price{
                        cell.lblSelingPrice.text = "$ \(price)"
                    }
                    
                }
            }
            
            if let wish = newArriv.wish{
                
                if wish == "1"{
                    
                    cell.imgHeart.image = #imageLiteral(resourceName: "heart (3)")
                    
                }
                else{
                    cell.imgHeart.image = #imageLiteral(resourceName: "heart (2)")
                }
                
            }
            cell.btnHeart.tag = indexPath.item
            cell.btnHeart.addTarget(self, action: #selector(self.appcetAction(_:)), for: .touchUpInside)
            
            if let img = newArriv.pro_image{
                cell.imgBackground.sd_setImage(with: URL(string: img ), placeholderImage: UIImage(named: ""))
            }
            
        }
        else{
            let newArriv = featureData[indexPath.row]
            cell.lblProductName.text = newArriv.pro_title
            
            if let discount = newArriv.pro_discount{
                
                
                if discount == "0" {
                    if let price = newArriv.pro_regular_price{
                        cell.lblFinalPrice.text = "$ \(price)"
                    }
                    
                    
                    cell.lblSelingPrice.isHidden = true
                    cell.lblLine.isHidden = true
                    cell.lblDiscount.isHidden = true
                }
                else{
                    if let price = newArriv.pro_sale_price{
                        cell.lblFinalPrice.text = "$ \(price)"
                    }
                    
                    cell.lblSelingPrice.isHidden = false
                    cell.lblLine.isHidden = false
                    cell.lblDiscount.isHidden = false
                    cell.lblDiscount.text = "\(discount)% OFF"
                    
                    if let price = newArriv.pro_regular_price{
                        cell.lblSelingPrice.text = "$ \(price)"
                    }
                }
            }
            if let img = newArriv.pro_image{
                cell.imgBackground.sd_setImage(with: URL(string: img ), placeholderImage: UIImage(named: ""))
            }
        }
        return cell
    }
        
    @objc func appcetAction(_ sender: UIButton) {
        
        print(sender.tag)
        
        let indexpathh = IndexPath(item: sender.tag, section: 0)
        if let cell = self.collectionViewFeatured.cellForItem(at: indexpathh) as? FeaturedCollectionVCell{
            
            if cell.imgHeart.image == #imageLiteral(resourceName: "heart (2)"){
                cell.imgHeart.image = #imageLiteral(resourceName: "heart (3)")
                HUD.show(.labeledProgress(title: "", subtitle: "Getting products for you..."))
                let userData = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
                
                let params : [String:Any] = ["user_id":"\(userData.user_id ?? "")",
                    
                    "product_id":"\(newArrival[sender.tag].pro_id ?? "")"]
                
                service.getResponseFromServerByPostMethod(parametrs: params, url: "add_to_wishlist.php?") { (results) in
                    
                    let status = results["status"] as? String ?? ""
                    if status == "1"{
                        HUD.hide()
                        Helper.showSnackBar(with: results["message"] as? String ?? "")
                        self.collectionViewFeatured.reloadData()
                    }else{
                        HUD.hide()
                        Helper.showSnackBar(with: results["message"] as? String ?? "")
                    }
                }
            }
            else{
                cell.imgHeart.image = #imageLiteral(resourceName: "heart (2)")
                
                HUD.show(.labeledProgress(title: "", subtitle: "Getting products for you..."))
                let userData = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
                
                let params : [String:Any] = ["user_id":"\(userData.user_id ?? "")",
                    
                    "product_id":"\(newArrival[sender.tag].pro_id ?? "")"]
                
                service.getResponseFromServerByPostMethod(parametrs: params, url: "remove_wishlist.php?") { (results) in
                    
                    let status = results["status"] as? String ?? ""
                    if status == "1"{
                        HUD.hide()
                        Helper.showSnackBar(with: results["message"] as? String ?? "")
                        self.collectionViewFeatured.reloadData()
                    }else{
                        HUD.hide()
                        Helper.showSnackBar(with: results["message"] as? String ?? "")
                    }
                }
            }
        }
    }
    
    @objc func declineAction(_ sender: UIButton) {
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       return CGSize(width: collectionView.frame.size.width/2, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if lblHeading.text == "New Arrial"{
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CategoryDetailViewC") as! CategoryDetailViewC
//
//            guard let p_Id = newArrival[indexPath.row].pro_id else{ return }
//
//            nextViewController.cat_id = "\(p_Id)"
//            navigationController?.pushViewController(nextViewController, animated: true)
            
            delegate?.cellTapped()
        }
        else{
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CategoryDetailViewC") as! CategoryDetailViewC
//
//            guard let p_Id = categoryData[indexPath.row].cat_id else{ return }
//            guard let catName = categoryData[indexPath.row].cat_name else{ return }
//            nextViewController.heading = catName
//            nextViewController.cat_id = "\(p_Id)"
//            self.tabBarController?.tabBar.isHidden = true
//            // nextViewController.lblHeading.text = categoryData[indexPath.row].cat_name
//            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
}

