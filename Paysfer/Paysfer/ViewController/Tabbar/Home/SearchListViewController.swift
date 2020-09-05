//
//  SearchListViewController.swift
//  Paysfer
//
//  Created by SUBHASH KUMAR on 05/09/20.
//  Copyright © 2020 VISHAL VERMA. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import SideMenu
import SDLoader
import PKHUD
import ProgressHUD
import SVProgressHUD

class SearchListViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UISearchBarDelegate {
    
    

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var categoryBtn: UIButton!
   @IBOutlet weak var lblCart: UILabel!
    
     let service = ServerHandler()
     var collnKey = String()
    var featureData = [FeatureModel]()
       var newArrival = [NewArrivalModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Helper.cornerCircle(lblCart)
        searchBar.delegate = self
        categoryBtn.addTarget(self, action: #selector(cartDetailsScreen), for: .touchUpInside)
        backBtn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
        self.categoryCollectionView.register(UINib.init(nibName: "FeaturedCollectionVCell", bundle: nil), forCellWithReuseIdentifier: FeaturedCollectionVCell.reuseId)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    @objc func backBtnAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
         searchBar.resignFirstResponder()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      //  searchActive = false
        if !(searchBar.text ?? "").isEmpty{
            self.getProductDetails(searchBar.text ?? "")
        }
        searchBar.resignFirstResponder()
    }
    
    func getProductDetails(_ productName:String){
        HUD.show(.labeledProgress(title: "", subtitle: "Getting products for you..."))
                let userData = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
                
                let params : [String:Any] = ["user_id":"\(userData.user_id ?? "")",
                    "title":"\(productName)",
                    ]
                
                service.getResponseFromServerByPostMethod(parametrs: params, url: "all_search_pro.php?") { (results) in
                    
                    let status = results["status"] as? String ?? ""
                    if status == "1"{
                        HUD.hide()
                        Helper.showSnackBar(with: results["message"] as? String ?? "")
                        if let quets = results["data"] as? [[String:Any]]{
                            print(quets)
                            self.newArrival = []
                            for item in quets{
                                print(item)
                                self.newArrival.append(NewArrivalModel(item))
                            }
                        }
                                        
                        self.categoryCollectionView.reloadData()
                        
                    }else{
                        HUD.hide()
                        Helper.showSnackBar(with: results["message"] as? String ?? "")
                    }
                }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.newArrival.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedCollectionVCell", for: indexPath) as! FeaturedCollectionVCell
        
        if #available(iOS 13.0, *) {
            cell.vwBackground.layer.shadowColor = UIColor.black.cgColor
        } else {
            cell.vwBackground.layer.shadowColor = UIColor.black.cgColor
        }
        cell.vwBackground.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        cell.vwBackground.layer.shadowRadius = 5
        cell.vwBackground.layer.shadowOpacity = 0.3
        cell.vwBackground.layer.cornerRadius = 8
        cell.vwBottomBg.roundedView()
        cell.imgBackground.roundedimgView()
        if newArrival.count>0{
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
                   
                   if let variablePro = newArriv.variable_pro{
                       if variablePro == "0"{
                           //addtoCartfeatureData
                           cell.btnAddToCart.tag = indexPath.item
                           cell.btnAddToCart.addTarget(self, action: #selector(self.addtoCartNewArrival(_:)), for: .touchUpInside)
                       }else{
                           cell.btnAddToCart.tag = indexPath.item
                           cell.btnAddToCart.addTarget(self, action: #selector(self.detailScreenNewArrival(_:)), for: .touchUpInside)
                       }
                   }
                   
                   self.collnKey = "1"
                   cell.btnHeart.tag = indexPath.item
                   cell.btnHeart.addTarget(self, action: #selector(self.appcetAction(_:)), for: .touchUpInside)
                   
                   if let img = newArriv.pro_image{
                       cell.imgBackground.sd_setImage(with: URL(string: img ), placeholderImage: UIImage(named: ""))
                   }
                   
        }
       
      
        
       
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ProductDetailViewC") as! ProductDetailViewC
        
        guard let p_Id = newArrival[indexPath.row].pro_id else{ return }
        nextViewController.p_id = p_Id
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
     @objc func addtoCartNewArrival(_ sender: UIButton) {
         HUD.show(.labeledProgress(title: "", subtitle: "Getting products for you..."))
         let userData = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
         
         let params : [String:Any] = ["user_id":"\(userData.user_id ?? "")",
                         
             "product_id":"\(newArrival[sender.tag].pro_id ?? "")",
             "variation_id":"0",
             "qty":"1"]
         
         service.getResponseFromServerByPostMethod(parametrs: params, url: "add_to_cart.php?") { (results) in
             
             let status = results["status"] as? String ?? ""
             if status == "1"{
                 HUD.hide()
                 Helper.showSnackBar(with: results["message"] as? String ?? "")
                                 
                                 
                 DispatchQueue.main.async {
                     
                    // self.homeProductData()
                     
                 }
                 
             }else{
                 HUD.hide()
                 Helper.showSnackBar(with: results["message"] as? String ?? "")
             }
         }
     }
    
    @objc func addtoCartfeatureData(_ sender: UIButton) {
              HUD.show(.labeledProgress(title: "", subtitle: "Getting products for you..."))
              let userData = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
              
              let params : [String:Any] = ["user_id":"\(userData.user_id ?? "")",
                              
                  "product_id":"\(featureData[sender.tag].pro_id ?? "")",
                  "variation_id":"0",
                  "qty":"1"]
              
              service.getResponseFromServerByPostMethod(parametrs: params, url: "add_to_cart.php?") { (results) in
                  
                  let status = results["status"] as? String ?? ""
                  if status == "1"{
                      HUD.hide()
                      Helper.showSnackBar(with: results["message"] as? String ?? "")
                                      
                                      
                      DispatchQueue.main.async {
                          
                        //  self.homeProductData()
                          
                      }
                      
                  }else{
                      HUD.hide()
                      Helper.showSnackBar(with: results["message"] as? String ?? "")
                  }
              }
          }
       

    
    
    
    @objc func appcetAction(_ sender: UIButton) {
           
           print(sender.tag)
           
           let indexpathh = IndexPath(item: sender.tag, section: 0)
           if let cell = self.categoryCollectionView.cellForItem(at: indexpathh) as? FeaturedCollectionVCell{
               
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
                           
                           let count = results["wish_count"] as? String ?? ""
                           
                           
                           
                           
                           DispatchQueue.main.async {
                               
                               if let tabItems = self.tabBarController?.tabBar.items {
                                   // In this case we want to modify the badge number of the third tab:
                                   let tabItem = tabItems[1]
                                   if count != ""{
                                       tabItem.badgeValue = count
                                   }
                                   else{
                                       tabItem.badgeValue = nil
                                   }
                                  // self.homeProductData()
                                   
                               }
                               
                               //   self.newArribleCollection.reloadData()
                           }
                           
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
                           let count = results["wish_count"] as? String ?? ""
                           
                                                   
                           DispatchQueue.main.async {
                               if let tabItems = self.tabBarController?.tabBar.items {
                                   // In this case we want to modify the badge number of the third tab:
                                   let tabItem = tabItems[1]
                                   tabItem.badgeValue = count
                                 //  self.homeProductData()
                               }
                               //  self.newArribleCollection.reloadData()
                           }
                           
                       }else{
                           HUD.hide()
                           Helper.showSnackBar(with: results["message"] as? String ?? "")
                       }
                   }
               }
           }
       }
       
    
    @objc func detailScreenNewArrival(_ sender: UIButton) {
           
           let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
           let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ProductDetailViewC") as! ProductDetailViewC
           
           guard let p_Id = newArrival[sender.tag].pro_id else{ return }
           
           nextViewController.p_id = p_Id
           self.tabBarController?.tabBar.isHidden = true
           self.navigationController?.pushViewController(nextViewController, animated: true)
       }
    
    
    @objc func cartDetailsScreen(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CartDetailViewController") as! CartDetailViewController
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}


extension SearchListViewController:UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
          return CGSize(width: collectionView.frame.size.width/2-10, height: collectionView.frame.size.width/2+120)
    
    }
    
}
