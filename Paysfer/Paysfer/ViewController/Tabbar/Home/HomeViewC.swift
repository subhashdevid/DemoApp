//
//  HomeViewC.swift
//  Paysfer
//
//  Created by VISHAL VERMA on 10/06/20.
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


struct ImagebModel{
    var id:String?
    var image:String?
    
    init(_ dict: [String: Any]) {
        self.id = dict["id"] as? String
        self.image = dict["image"] as? String
    }
}


struct CategoryModel{
    var cat_id:Int?
    var cat_name:String?
    var cat_slug:String?
    var image:String?
    var s_cat:[s_cat] = []
    
    init(_ dict: [String: Any]) {
        self.cat_id = dict["cat_id"] as? Int
        self.cat_name = dict["cat_name"] as? String
        self.cat_slug = dict["cat_slug"] as? String
        self.image = dict["image"] as? String
        if let val = dict["s_cat"] as? [s_cat] {
            for item in val {
                self.s_cat.append(item)
            }
        }
    }
}

struct s_cat {
    var sub_id:Int?
    var sub_name:String?
    var sub_slug:String?
    init(_ dict: [String:Any]) {
        self.sub_id = dict["sub_id"] as? Int
        self.sub_name = dict["sub_name"] as? String
        self.sub_slug = dict["sub_slug"] as? String
    }
}

struct FeatureModel{
    var pro_discount:String?
    var pro_id:String?
    var pro_image:String?
    var pro_regular_price:String?
    var pro_sale_price:String?
    var pro_title:String?
    var variable_pro:String?
    var wish:String?
    
    init(_ dict: [String: Any]) {
        self.pro_discount = dict["pro_discount"] as? String
        self.pro_id = dict["pro_id"] as? String
        self.pro_image = dict["pro_image"] as? String
        self.pro_regular_price = dict["pro_regular_price"] as? String
        self.pro_sale_price = dict["pro_sale_price"] as? String
        self.pro_title = dict["pro_title"] as? String
        self.variable_pro = dict["variable_pro"] as? String
        self.wish = dict["wish"] as? String
    }
}
struct NewArrivalModel{
    var pro_discount:String?
    var pro_id:String?
    var pro_image:String?
    var pro_regular_price:String?
    var pro_sale_price:String?
    var pro_title:String?
    var variable_pro:String?
    var wish:String?
    
    
    init(_ dict: [String: Any]) {
        self.pro_discount = dict["pro_discount"] as? String
        self.pro_id = dict["pro_id"] as? String
        self.pro_image = dict["pro_image"] as? String
        self.pro_regular_price = dict["pro_regular_price"] as? String
        self.pro_sale_price = dict["pro_sale_price"] as? String
        self.pro_title = dict["pro_title"] as? String
        self.variable_pro = dict["variable_pro"] as? String
        self.wish = dict["wish"] as? String
        
    }
}

class HomeViewC: UIViewController {
   
    
    
    
    @IBOutlet weak var tutorialCollection: UICollectionView!
    @IBOutlet weak var categryCollection: UICollectionView!
    @IBOutlet weak var pgControl: UIPageControl!
    
    @IBOutlet weak var tblFeatured: UITableView!
    @IBOutlet weak var tblMenu: UITableView!
    @IBOutlet weak var vwMenu: UIView!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var lblCart: UILabel!
    
    @IBOutlet weak var featuredCollection: UICollectionView!
    @IBOutlet weak var newArribleCollection: UICollectionView!

    
    internal var arrayImage = [UIImage]()
    var presentingEndA = UISlider()
    let service = ServerHandler()
    var imageData = [ImagebModel]()
    var categoryData = [CategoryModel]()
    
    var featureData = [FeatureModel]()
    var newArrival = [NewArrivalModel]()
    
    var arrayName = [String]()
    let defaults = UserDefaults.standard
    
    var collnKey = String()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageDataSlider()
        categoryApi()
        self.arrayImage = [#imageLiteral(resourceName: "login-reg")]
        
        Helper.cornerCircle(lblCart)
        
        SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
        setupSideMenu()
        self.tblFeatured.backgroundColor = .white
        self.tblFeatured.register(UINib.init(nibName: "FeaturedCell", bundle: nil), forCellReuseIdentifier: FeaturedCell.reuseId)
        
        self.featuredCollection.register(UINib.init(nibName: "FeaturedCollectionVCell", bundle: nil), forCellWithReuseIdentifier: FeaturedCollectionVCell.reuseId)
        self.newArribleCollection.register(UINib.init(nibName: "FeaturedCollectionVCell", bundle: nil), forCellWithReuseIdentifier: FeaturedCollectionVCell.reuseId)
        
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(moveFrame), userInfo: nil, repeats: true)
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
       homeProductData()
    }
    override func viewDidAppear(_ animated: Bool) {
           homeProductData()
           
           
       }
    private func setupSideMenu() {
        
        SideMenuManager.default.leftMenuNavigationController = storyboard?.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? SideMenuNavigationController
        
        
        SideMenuManager.default.addPanGestureToPresent(toView: navigationController!.navigationBar)
        SideMenuManager.default.addScreenEdgePanGesturesToPresent(toView: view)
    }
    
    
    override func viewDidLayoutSubviews() {
        pgControl.subviews.forEach {
            $0.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func cartDetailsScreen(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CartDetailViewController") as! CartDetailViewController
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    
    @objc func moveFrame(){
        
        if pgControl.currentPage < imageData.count - 1{
            
            pgControl.currentPage = pgControl.currentPage + 1
            let collectionBounds = self.tutorialCollection.bounds
            let contentOffset = CGFloat(floor(self.tutorialCollection.contentOffset.x + collectionBounds.size.width))
            self.moveToFrame(contentOffset: contentOffset)
        }
            
        else if pgControl.currentPage == imageData.count - 1{
            
            pgControl.currentPage = 0
            let cc = imageData.count - 1
            let collectionBounds = self.tutorialCollection.bounds
            let contentOffset = CGFloat(floor(self.tutorialCollection.contentOffset.x - CGFloat(cc) * (collectionBounds.size.width)))
            self.moveToFrame(contentOffset: contentOffset)
        }
    }
    
    func homeProductData(){
        
        featureData.removeAll()
        newArrival.removeAll()
        
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
                        self.featuredCollection.reloadData()
                        self.newArribleCollection.reloadData()
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
    
    
    func imageDataSlider(){
        
        
        
       // HUD.show(.labeledSuccess(title: "ytr", subtitle: ""), onView: self.view)
        HUD.show(.labeledProgress(title: "", subtitle: "Getting products for you..."))
        service.getResponseFromServer(parametrs: "slider.php") { (results) in
            let status = results["status"] as? String ?? ""
            if status == "1"{
               HUD.hide()
                if let quets = results["data"] as? [[String:Any]]{
                    for item in quets{
                        //  print(item)
                        self.imageData.append(ImagebModel(item))
                    }
                    DispatchQueue.main.async {
                        self.tutorialCollection.reloadData()
                    }
                    
                    self.pgControl.numberOfPages = self.imageData.count
                }
            }else{
                HUD.hide()
                let alertController = UIAlertController(title: "Failure", message: results["message"] as? String ?? "", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel) {
                    UIAlertAction in
                }
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
    func categoryApi(){
      HUD.show(.labeledProgress(title: "", subtitle: "Getting products for you..."))
        
        service.getResponseFromServer(parametrs: "demo_category.php?category=category") { (results) in
            let status = results["status"] as? String ?? ""
            if status == "1"{
                HUD.hide()
                if let quets = results["data"] as? [[String:Any]]{
                    for item in quets{
                        //  print(item)
                        let newarr = item["cat_name"] as? String ?? ""
                        
                        self.arrayName.append(newarr)
                        
                        
                       // self.defaults.set(self.arrayName, forKey: "SavedStringArray")
                        

                        
                        self.categoryData.append(CategoryModel(item))
                    }
                    UserDefaults.standard.set(self.arrayName, forKey: "SavedStringArray")

                    
                    
                    
                    DispatchQueue.main.async {
                        self.categryCollection.reloadData()
                    }
                }
            }else{
                HUD.hide()
                let alertController = UIAlertController(title: "Failure", message: results["message"] as? String ?? "", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel) {
                    UIAlertAction in
                }
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func backGroundMenuBtn(_ sender: UIButton) {
                
    }
    
    @IBAction func menuAction(_ sender: UIButton) {
        // Define the menu
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    @objc internal func moveToFrame(contentOffset : CGFloat) {
        let frame: CGRect = CGRect(x : contentOffset ,y : self.tutorialCollection.contentOffset.y ,width : self.tutorialCollection.frame.width,height : self.tutorialCollection.frame.height)
        self.tutorialCollection.scrollRectToVisible(frame, animated: true)
    }
    
    @IBAction func pageControl(_ sender: UIPageControl) {
        let x = CGFloat(pgControl.currentPage) * tutorialCollection.frame.size.width
        tutorialCollection.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }
    
}
extension HomeViewC:UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tutorialCollection{
            return imageData.count
        }
        else if collectionView == featuredCollection{
            return featureData.count
        }
            
        else if collectionView == newArribleCollection{
            return newArrival.count
        }
        else{
            return categoryData.count
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == tutorialCollection{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCollectionViewCell", for: indexPath) as! BannerCollectionViewCell
            
            if let img = imageData[indexPath.row].image{
                
                cell.imgBackground.sd_setImage(with: URL(string: img ), placeholderImage: UIImage(named: ""))
            }
            return cell
        }
        else if collectionView == featuredCollection{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedCollectionVCell", for: indexPath) as! FeaturedCollectionVCell
            
            cell.vwBackground.layer.shadowColor = UIColor.black.cgColor
            cell.vwBackground.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
            cell.vwBackground.layer.shadowRadius = 5
            cell.vwBackground.layer.shadowOpacity = 0.3
            cell.vwBackground.layer.cornerRadius = 8
            cell.vwBottomBg.roundedView()
            cell.imgBackground.roundedimgView()
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
                    
                    cell.btnAddToCart.tag = indexPath.item
                    cell.btnAddToCart.addTarget(self, action: #selector(self.addtoCartfeatureData(_:)), for: .touchUpInside)
                }
                else{
                    cell.btnAddToCart.tag = indexPath.item
                    cell.btnAddToCart.addTarget(self, action: #selector(self.detailScreenfeatureData(_:)), for: .touchUpInside)
                }
            }
            
            cell.btnHeart.tag = indexPath.item
            cell.btnHeart.addTarget(self, action: #selector(self.newappcetAction(_:)), for: .touchUpInside)
            
            return cell
        }
            
        else if collectionView == newArribleCollection{
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
            
            return cell
        }
            
            
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatogeryCCell", for: indexPath) as! CatogeryCCell
            cell.backgroundColor = .white
            // cell.imgBackground.layer.cornerRadius = cell.imgBackground.frame.width/2
            
            if let img = categoryData[indexPath.row].image{
                
                cell.imgBackground.sd_setImage(with: URL(string: img ), placeholderImage: UIImage(named: ""))
            }
            
            if let categName = categoryData[indexPath.row].cat_name{
                UserDefaults.standard.set(categName, forKey: "SavedStringArray")
                cell.lblCategory.text = categName
            }
            return cell
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
                       
                       self.homeProductData()
                       
                   }
                   
               }else{
                   HUD.hide()
                   Helper.showSnackBar(with: results["message"] as? String ?? "")
               }
           }
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
                    
                    self.homeProductData()
                    
                }
                
            }else{
                HUD.hide()
                Helper.showSnackBar(with: results["message"] as? String ?? "")
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
    
    @objc func detailScreenfeatureData(_ sender: UIButton) {
        
        //     let indexpathh = IndexPath(item: sender.tag, section: 0)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ProductDetailViewC") as! ProductDetailViewC
        
        guard let p_Id = featureData[sender.tag].pro_id else{ return }
        
        nextViewController.p_id = p_Id
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @objc func appcetAction(_ sender: UIButton) {
        
        print(sender.tag)
        
        let indexpathh = IndexPath(item: sender.tag, section: 0)
        if let cell = self.newArribleCollection.cellForItem(at: indexpathh) as? FeaturedCollectionVCell{
            
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
                                self.homeProductData()
                                
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
                                self.homeProductData()
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
    
    
    @objc func newappcetAction(_ sender: UIButton) {
        
        print(sender.tag)
        
        let indexpathh = IndexPath(item: sender.tag, section: 0)
        if let cell = self.featuredCollection.cellForItem(at: indexpathh) as? FeaturedCollectionVCell{
            
            if cell.imgHeart.image == #imageLiteral(resourceName: "heart (2)"){
                cell.imgHeart.image = #imageLiteral(resourceName: "heart (3)")
                HUD.show(.labeledProgress(title: "", subtitle: "Getting products for you..."))
                let userData = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
                
                let params : [String:Any] = ["user_id":"\(userData.user_id ?? "")",
                    
                    "product_id":"\(featureData[sender.tag].pro_id ?? "")"]
                
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
                                self.homeProductData()
                                
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
                    
                    "product_id":"\(featureData[sender.tag].pro_id ?? "")"]
                
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
}

// MARK: - Collection View Delegates

extension HomeViewC:UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        if collectionView == tutorialCollection{
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }
            
       else if collectionView == categryCollection{
            return CGSize(width: collectionView.frame.size.width/3 - 10, height: collectionView.frame.size.height)
        }
            
        else {
            
            
            return CGSize(width: collectionView.frame.size.width/2, height: collectionView.frame.size.height)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categryCollection{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CategoryDetailViewC") as! CategoryDetailViewC
            
            guard let p_Id = categoryData[indexPath.row].cat_id else{ return }
            guard let catName = categoryData[indexPath.row].cat_name else{ return }
            nextViewController.heading = catName
            nextViewController.cat_id = "\(p_Id)"
            self.tabBarController?.tabBar.isHidden = true
            // nextViewController.lblHeading.text = categoryData[indexPath.row].cat_name
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        
        else if collectionView == featuredCollection{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ProductDetailViewC") as! ProductDetailViewC
            
            guard let p_Id = featureData[indexPath.row].pro_id else{ return }
           
            nextViewController.p_id = p_Id
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        else if collectionView == newArribleCollection{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "ProductDetailViewC") as! ProductDetailViewC
            
            guard let p_Id = newArrival[indexPath.row].pro_id else{ return }
            nextViewController.p_id = p_Id
            self.tabBarController?.tabBar.isHidden = true
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
}

// MARK: - Scroll View Delegates

extension HomeViewC:UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        pgControl.currentPage = Int(x/w)
    }
}

extension UIView{
    func roundedView(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
            byRoundingCorners: [.bottomLeft , .bottomRight],
            cornerRadii: CGSize(width: 8, height: 18))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}

extension UIImageView{
    func roundedimgView(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
            byRoundingCorners: [.topRight , .topLeft],
            cornerRadii: CGSize(width: 8, height: 8))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}
