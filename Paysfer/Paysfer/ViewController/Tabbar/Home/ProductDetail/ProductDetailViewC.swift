//
//  ProductDetailViewC.swift
//  Paysfer
//
//  Created by VISHAL VERMA on 20/07/20.
//  Copyright © 2020 VISHAL VERMA. All rights reserved.
//

import UIKit
import PKHUD


struct GallerybModel{
    var image:String?
    
    init(_ dict: [String: Any]) {
        self.image = dict["galley"] as? String
    }
}


class ProductDetailViewC: UIViewController {
    
    
    @IBOutlet weak var imgCollectionVw: UICollectionView!
    @IBOutlet weak var pgControl: UIPageControl!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var collectionViewFeatured: UICollectionView!
    @IBOutlet weak var lblHeading: UILabel!
    
    
    @IBOutlet weak var lblFinalPrice: UILabel!
    @IBOutlet weak var lblCutPrice: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    
    @IBOutlet weak var lblLine: UILabel!
    
    @IBOutlet weak var vwBackground: UIView!
    @IBOutlet weak var lblCart: UILabel!
    @IBOutlet weak var imgHeart: UIImageView!

    
    internal var arrayImage = [UIImage]()
    var presentingEndA = UISlider()
    let service = ServerHandler()
    var imageData = [GallerybModel]()
    var categoryData = [CategoryModel]()
    
    var featureData = [FeatureModel]()
    var newArrival = [NewArrivalModel]()
    var p_id = String()
    
    
    let defaults = UserDefaults.standard
    
    var productData = [FeatureModel]()
    var cat_id = String()
    var heading = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgCollectionVw.backgroundColor = .white
        Helper.cornerCircle(lblCart)
        homeProductData()
        vwBackground.layer.shadowColor = UIColor.black.cgColor
        vwBackground.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        vwBackground.layer.shadowRadius = 2
        vwBackground.layer.shadowOpacity = 0.2
        vwBackground.layer.cornerRadius = 4
        
        self.collectionViewFeatured.backgroundColor = .white
        self.collectionViewFeatured.register(UINib.init(nibName: "FeaturedCollectionVCell", bundle: nil), forCellWithReuseIdentifier: FeaturedCollectionVCell.reuseId)
        productDetail()
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(moveFrame), userInfo: nil, repeats: true)
        
    }
    override func viewDidAppear(_ animated: Bool) {
           homeProductData()
           
           
       }
    
    
    
    @IBAction func cartDetailsScreen(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CartDetailViewController") as! CartDetailViewController
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        pgControl.subviews.forEach {
            $0.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }
    }
    
    @IBAction func wishListAction(_ sender: Any) {
        
        if self.imgHeart.image == #imageLiteral(resourceName: "heart (2)"){
            self.imgHeart.image = #imageLiteral(resourceName: "heart (3)")
            HUD.show(.labeledProgress(title: "", subtitle: "Getting products for you..."))
            let userData = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
            
            let params : [String:Any] = ["user_id":"\(userData.user_id ?? "")",
                
                "product_id":"\(productData[0].pro_id ?? "")"]
            
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
            self.imgHeart.image = #imageLiteral(resourceName: "heart (2)")
            
            HUD.show(.labeledProgress(title: "", subtitle: "Getting products for you..."))
            let userData = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
            
            let params : [String:Any] = ["user_id":"\(userData.user_id ?? "")",
                
                "product_id":"\(productData[0].pro_id ?? "")"]
            
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
    @IBAction func AddToCartAction(_ sender: Any) {
        
    }
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func moveFrame(){
        
        if pgControl.currentPage < imageData.count - 1{
            
            pgControl.currentPage = pgControl.currentPage + 1
            let collectionBounds = self.imgCollectionVw.bounds
            let contentOffset = CGFloat(floor(self.imgCollectionVw.contentOffset.x + collectionBounds.size.width))
            self.moveToFrame(contentOffset: contentOffset)
        }
            
        else if pgControl.currentPage == imageData.count - 1{
            
            pgControl.currentPage = 0
            let cc = imageData.count - 1
            let collectionBounds = self.imgCollectionVw.bounds
            let contentOffset = CGFloat(floor(self.imgCollectionVw.contentOffset.x - CGFloat(cc) * (collectionBounds.size.width)))
            self.moveToFrame(contentOffset: contentOffset)
        }
    }
    
    
    @objc internal func moveToFrame(contentOffset : CGFloat) {
        let frame: CGRect = CGRect(x : contentOffset ,y : self.imgCollectionVw.contentOffset.y ,width : self.imgCollectionVw.frame.width,height : self.imgCollectionVw.frame.height)
        self.imgCollectionVw.scrollRectToVisible(frame, animated: true)
    }
    
    @IBAction func pageControl(_ sender: UIPageControl) {
        let x = CGFloat(pgControl.currentPage) * imgCollectionVw.frame.size.width
        imgCollectionVw.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }
    
    
    func homeProductData(){
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
            }else{
                Helper.showSnackBar(with: results["message"] as? String ?? "")
            }
        }
    }
    
    func productDetail(){
        
        let userData = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
        HUD.show(.labeledProgress(title: "", subtitle: "Getting products for you..."))
        
        service.getResponseFromServer(parametrs: "pro_details.php?product_id=\(p_id)&&user_id=\( userData.user_id ?? "")") { (results) in
            let status = results["status"] as? String ?? ""
            if status == "1"{
                HUD.hide()
                //                     let count = results["wish_count"] as? String ?? ""
                //
                //                    UserDefaults.standard.set(count, forKey: "wishC")
                
                if let quets = results["data"] as? [String:Any]{
                    
                    let longdes = quets["product_full_desc"] as? String ?? ""
                    let shortdes = quets["product_short_desc"] as? String ?? ""
                    
                    let title = quets["product_title"] as? String ?? ""
                    
                    let regular_price = quets["regular_price"] as? String ?? ""
                    
                    let sale_price = quets["sale_price"] as? String ?? ""
                    
                    if let wish = quets["wish"] as? String {
                        if wish == "1"{
                            self.imgHeart.image = #imageLiteral(resourceName: "heart (3)")
                        }
                        else{
                            self.imgHeart.image = #imageLiteral(resourceName: "heart (2)")
                        }
                    }
                    
                    
                    if sale_price != ""{
                        self.lblFinalPrice.text = "$" + sale_price
                        self.lblCutPrice.text = "$" + regular_price
                        self.lblCutPrice.isHidden = false
                        self.lblLine.isHidden = false
                        
                    }
                    else{
                        self.lblFinalPrice.text = "$105"
                        self.lblCutPrice.isHidden = true
                        self.lblLine.isHidden = true
                    }
                    
                    
                    self.lblHeading.text = title
                    self.lblProductName.text = title
                    
                    // let j = quets["product_short_desc"] as? String ?? ""
                    
                    
                    
                    
                    self.lblDescription.text = shortdes.html2String + "\n" + longdes.html2String
                    
                    if let feature = quets["gallery"] as? [[String:Any]]{
                        for item in feature{
                            print(item)
                            self.imageData.append(GallerybModel(item))
                        }
                    }
                    
                    if let relatedfeature = quets["rel_products"] as? [[String:Any]]{
                        for item in relatedfeature{
                            print(item)
                            self.productData.append(FeatureModel(item))
                        }
                        
                        
                        DispatchQueue.main.async {
                            self.collectionViewFeatured.reloadData()
                        }
                    }
                    
                    //                        if let feature = quets["new_arrival"] as? [[String:Any]]{
                    //                            for item in feature{
                    //                                print(item)
                    //                                self.newArrival.append(NewArrivalModel(item))
                    //                            }
                    //                        }
                    DispatchQueue.main.async {
                        self.imgCollectionVw.reloadData()
                    }
                    
                    self.pgControl.numberOfPages = self.imageData.count
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
extension ProductDetailViewC:UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == imgCollectionVw{
            return imageData.count
        }
        else{
            return productData.count

        }
       
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            if collectionView == imgCollectionVw{

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCollectionViewCell", for: indexPath) as! BannerCollectionViewCell
            
            if let img = imageData[indexPath.row].image{
                
                cell.imgBackground.sd_setImage(with: URL(string: img ), placeholderImage: UIImage(named: ""))
            }
            return cell
        }
            else{
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
                
                
                return cell
        }
            
      
        
    }
}

// MARK: - Collection View Delegates

extension ProductDetailViewC:UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        if collectionView == imgCollectionVw{
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }
        else{
            return CGSize(width: collectionView.frame.size.width/2, height: collectionView.frame.size.height)
        }
        
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

// MARK: - Scroll View Delegates

extension ProductDetailViewC:UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        pgControl.currentPage = Int(x/w)
    }
}

extension String {

    var html2AttributedString: NSAttributedString? {
        do {
            guard let data = data(using: String.Encoding.utf8) else {
                return NSAttributedString(string: "")
            }
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print(error)
            return NSAttributedString(string: "")
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
