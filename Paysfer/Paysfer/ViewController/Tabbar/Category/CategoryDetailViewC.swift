//
//  CategoryDetailViewC.swift
//  Paysfer
//
//  Created by VISHAL VERMA on 22/06/20.
//  Copyright © 2020 VISHAL VERMA. All rights reserved.
//

import UIKit
import PKHUD

class CategoryDetailViewC: UIViewController {
    
    static let reuseId = "FeaturedCell"
      
      @IBOutlet weak var collectionViewFeatured: UICollectionView!
      @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var lblCart: UILabel!

    
      var productData = [FeatureModel]()
          let service = ServerHandler()
    var cat_id = String()
    var heading = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewFeatured.backgroundColor = .white
        registerNibFiles()
             homeProductData()
        Helper.cornerCircle(lblCart)
        self.lblHeading.text = self.heading

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
        
        
        func homeProductData(){
            
              let userData = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
            HUD.show(.labeledProgress(title: "", subtitle: "Getting products for you..."))
            service.getResponseFromServer(parametrs: "category_product.php?cat_id=\(cat_id)&&user_id=\( userData.user_id ?? "")") { (results) in
                let status = results["status"] as? String ?? ""
                if status == "1"{
                    HUD.hide()
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
    //                let alertController = UIAlertController(title: "Failure", message: results["message"] as? String ?? "", preferredStyle: .alert)
    //
    //                let cancelAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel) {
    //                    UIAlertAction in
    //                }
    //                alertController.addAction(cancelAction)
                    
                }
            }
        }
        
        @IBAction func backBtnAction(_ sender: Any) {
            self.tabBarController?.tabBar.isHidden = false
             self.navigationController?.popViewController(animated: true)
         }
        
    }

extension CategoryDetailViewC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
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
        if let img = newArriv.pro_image{
            cell.imgBackground.sd_setImage(with: URL(string: img ), placeholderImage: UIImage(named: ""))
        }
        
        if let wish = newArriv.wish{
            if wish == "1"{
                cell.imgHeart.image = #imageLiteral(resourceName: "heart (3)")
            }
            else{
                cell.imgHeart.image = #imageLiteral(resourceName: "heart (2)")
            }
        }
        return cell
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
