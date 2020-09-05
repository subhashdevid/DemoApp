//
//  MyWishListViewC.swift
//  Paysfer
//
//  Created by VISHAL VERMA on 23/06/20.
//  Copyright © 2020 VISHAL VERMA. All rights reserved.
//

import UIKit
import PKHUD

class MyWishListViewC: UIViewController {
    
    
    @IBOutlet weak var collectionViewFeatured: UICollectionView!
    
    @IBOutlet weak var lblHiddenTxt: UILabel!
    @IBOutlet weak var imgHidden: UIImageView!
    @IBOutlet weak var lblCart: UILabel!

    
    
    var productData = [FeatureModel]()
    let service = ServerHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNibFiles()
        
        Helper.cornerCircle(lblCart)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        homeProductData()
        carttData()
        
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        carttData()
        
    }
    
    @IBAction func cartDetailsScreen(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CartDetailViewController") as! CartDetailViewController
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func registerNibFiles(){
        self.collectionViewFeatured.register(UINib.init(nibName: "FeaturedCollectionVCell", bundle: nil), forCellWithReuseIdentifier: FeaturedCollectionVCell.reuseId)
        
    }
    func carttData(){
        
        
        
        let userData = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
        HUD.show(.labeledProgress(title: "", subtitle: "Getting products for you..."))
        
        service.getResponseFromServer(parametrs: "home_product.php?home_product=home_product&&user_id=\( userData.user_id ?? "")") { (results) in
            let status = results["status"] as? String ?? ""
            if status == "1"{
                HUD.hide()
                let count = results["wish_count"] as? String ?? ""
                
                if let cartCount = results["cart_count"] as? String {
                    
                    if cartCount != ""{
                        self.lblCart.isHidden = false
                        self.lblCart.text = cartCount
                    }else{
                        self.lblCart.isHidden = true
                    }
                    
                }
                if let tabItems = self.tabBarController?.tabBar.items {
                    // In this case we want to modify the badge number of the third tab:
                    let tabItem = tabItems[1]
                    if count != ""{
                        tabItem.badgeValue = count
                    }
                    else{
                        tabItem.badgeValue = nil
                    }
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
    
    func homeProductData(){
        
        productData.removeAll()
        collectionViewFeatured.isHidden = false

        let userData = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
        HUD.show(.labeledProgress(title: "", subtitle: "Getting products for you..."))
        service.getResponseFromServer(parametrs: "wishlist_details.php?user_id=\( userData.user_id ?? "")") { (results) in
            let status = results["status"] as? String ?? ""
            if status == "1"{
                HUD.hide()
                self.imgHidden.isHidden = true
                                           self.lblHiddenTxt.isHidden = true
                if let feature = results["data"] as? [[String:Any]]{
                    for item in feature{
                        print(item)
                        self.productData.append(FeatureModel(item))
                    }
                    
                    
                    DispatchQueue.main.async {
                        self.collectionViewFeatured.reloadData()
                    }
                }
            }else{
                
                HUD.hide()
                   DispatchQueue.main.async {
                                  if self.productData.count == 0{
                                      self.imgHidden.isHidden = false
                                      self.lblHiddenTxt.isHidden = false
                                      self.collectionViewFeatured.isHidden = true
                                  }
                                  else{
                                      self.imgHidden.isHidden = true
                                      self.lblHiddenTxt.isHidden = true
                                      self.collectionViewFeatured.isHidden = false
                                  }
                                  self.collectionViewFeatured.reloadData()
                              }
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

extension MyWishListViewC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return productData.count
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedCollectionVCell", for: indexPath) as! FeaturedCollectionVCell
        
        cell.vwBackground.layer.shadowColor = UIColor.black.cgColor
        cell.vwBackground.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        cell.vwBackground.layer.shadowRadius = 5
        cell.vwBackground.layer.shadowOpacity = 0.3
        cell.vwBackground.layer.cornerRadius = 8
        //r
        cell.vwBottomBg.roundedView()
        cell.imgBackground.roundedimgView()
        
        
        let newArriv = productData[indexPath.row]
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
        
//        if let variablePro = newArriv.variable_pro{
//            if variablePro == "0"{
//                //addtoCartfeatureData
//                cell.btnAddToCart.tag = indexPath.item
//                cell.btnAddToCart.addTarget(self, action: #selector(self.addtoCartNewArrival(_:)), for: .touchUpInside)
//            }else{
//
//            }
//        }
        cell.btnAddToCart.tag = indexPath.item
        cell.btnAddToCart.addTarget(self, action: #selector(self.detailScreenNewArrival(_:)), for: .touchUpInside)
        
        cell.btnHeart.tag = indexPath.item
        cell.btnHeart.addTarget(self, action: #selector(self.appcetAction(_:)), for: .touchUpInside)
        
        
        if let img = newArriv.pro_image{
            cell.imgBackground.sd_setImage(with: URL(string: img ), placeholderImage: UIImage(named: ""))
        }
        cell.imgHeart.image = #imageLiteral(resourceName: "heart (3)")
        
        return cell
    }
    
    
    @objc func addtoCartNewArrival(_ sender: UIButton) {
        HUD.show(.labeledProgress(title: "", subtitle: "Adding product your cart..."))
        let userData = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
        
        let params : [String:Any] = ["user_id":"\(userData.user_id ?? "")",
            
            "product_id":"\(productData[sender.tag].pro_id ?? "")",
            "variation_id":"0",
            "qty":"1"]
        
        service.getResponseFromServerByPostMethod(parametrs: params, url: "add_to_cart.php?") { (results) in
            
            let status = results["status"] as? String ?? ""
            if status == "1"{
                HUD.hide()
                Helper.showSnackBar(with: results["message"] as? String ?? "")
                
                DispatchQueue.main.async {
                    self.carttData()
                   // self.homeProductData()
                }
                
            }else{
                HUD.hide()
                Helper.showSnackBar(with: results["message"] as? String ?? "")
            }
        }
    }
     
     
     @objc func detailScreenNewArrival(_ sender: UIButton) {
        if let variablePro = productData[sender.tag].variable_pro{
            if variablePro == "0"{
                
                HUD.show(.labeledProgress(title: "", subtitle: "Adding product your cart..."))
                    let userData = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
                    
                    let params : [String:Any] = ["user_id":"\(userData.user_id ?? "")",
                        
                        "product_id":"\(productData[sender.tag].pro_id ?? "")",
                        "variation_id":"0",
                        "qty":"1"]
                    
                    service.getResponseFromServerByPostMethod(parametrs: params, url: "add_to_cart.php?") { (results) in
                        
                        let status = results["status"] as? String ?? ""
                        if status == "1"{
                            HUD.hide()
                            Helper.showSnackBar(with: results["message"] as? String ?? "")
                            
                            
                            DispatchQueue.main.async {
                                self.carttData()
                               // self.homeProductData()
                                
                            }
                            
                        }else{
                            HUD.hide()
                            Helper.showSnackBar(with: results["message"] as? String ?? "")
                        }
                    }
                
            }else{
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ProductDetailViewC") as! ProductDetailViewC
                
                guard let p_Id = productData[sender.tag].pro_id else{ return }
                
                nextViewController.p_id = p_Id
                self.tabBarController?.tabBar.isHidden = true
                self.navigationController?.pushViewController(nextViewController, animated: true)
            }
        }
     }
    
    
    @objc func appcetAction(_ sender: UIButton) {
        
        print(sender.tag)
        HUD.show(.labeledProgress(title: "", subtitle: "Getting products for you..."))
        let userData = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
        
        let params : [String:Any] = ["user_id":"\(userData.user_id ?? "")",
            
            "product_id":"\(productData[sender.tag].pro_id ?? "")"]
        
        service.getResponseFromServerByPostMethod(parametrs: params, url: "remove_wishlist.php?") { (results) in
            
            let status = results["status"] as? String ?? ""
            if status == "1"{
                HUD.hide()
                Helper.showSnackBar(with: results["message"] as? String ?? "")
                let count = results["wish_count"] as? String ?? ""
                
                
                DispatchQueue.main.async {
                    if let tabItems = self.tabBarController?.tabBar.items {
                        // In this case we want to modify the badge number of the third tab:
                        let tabItem = tabItems[1]
                        tabItem.badgeValue = count
                        self.homeProductData()
                        self.carttData()
                    }
                }
            }else{
                HUD.hide()
                Helper.showSnackBar(with: results["message"] as? String ?? "")
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionViewFeatured.frame.size.width/2 - 10, height:320)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewFeatured {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ProductDetailViewC") as! ProductDetailViewC
            
            guard let p_Id = productData[indexPath.row].pro_id else{ return }
            
            nextViewController.p_id = p_Id
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
}
