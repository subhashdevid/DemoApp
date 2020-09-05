//
//  CartDetailViewController.swift
//  Paysfer
//
//  Created by VISHAL VERMA on 10/08/20.
//  Copyright © 2020 VISHAL VERMA. All rights reserved.
//

import UIKit
import PKHUD

struct CartModel{
    var pro_discount:String?
    var pro_id:String?
    var pro_image:String?
    var pro_regular_price:String?
    var pro_sale_price:String?
    var pro_title:String?
    var variation_id:String?
    var rating:String?
    var quantity:String?
    
    init(_ dict: [String: Any]) {
        self.pro_discount = dict["pro_discount"] as? String
        self.pro_id = dict["pro_id"] as? String
        self.pro_image = dict["pro_image"] as? String
        self.pro_regular_price = dict["pro_regular_price"] as? String
        self.pro_sale_price = dict["pro_sale_price"] as? String
        self.pro_title = dict["pro_title"] as? String
        self.variation_id = dict["variation_id"] as? String
        self.rating = dict["rating"] as? String
        self.quantity = dict["quantity"] as? String
    }
}

class CartDetailViewController: UIViewController {
    
    @IBOutlet weak var totalAmountVw: UIView!
    @IBOutlet weak var tblCart: UITableView!
    @IBOutlet weak var lblTotalP: UILabel!
    @IBOutlet weak var submitPrice: UIButton!

    let service = ServerHandler()
    var cartData = [CartModel]()
    var totalP:Double = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.tblCart.backgroundColor = .white
        
        self.tblCart.register(UINib.init(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: CartTableViewCell.reuseId)
        self.submitPrice.addTarget(self, action: #selector(checkOut), for: .touchUpInside)
        cartDetail()
    }
    
    func cartDetail(){
        self.totalP = 0
        cartData.removeAll()
        let userData = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
        HUD.show(.labeledProgress(title: "", subtitle: "Getting products for you..."))
        
        service.getResponseFromServer(parametrs: "cart_details.php?user_id=\( userData.user_id ?? "")") { (results) in
            let status = results["status"] as? String ?? ""
            if status == "1"{
                HUD.hide()
                if let feature = results["data"] as? [[String:Any]]{
                    for item in feature{
                        print(item)
                        self.cartData.append(CartModel(item))
                        
                        let ss:String =  item["pro_regular_price"] as? String ?? "0"
                        let tt:String = item["pro_sale_price"] as? String ?? "0"
                        
                        let qty:String = item["quantity"] as? String ?? "0"
                         let qqtt = Int(qty) ?? 0
                        let rgP = Double(ss) ?? 0
                        let selP = Double(tt) ?? 0
                        
                        if tt == "" {
                            self.totalP = self.totalP + (rgP * Double(qqtt))
                        }
                        else{
                             self.totalP = self.totalP + (selP * Double(qqtt))
                        }
                     //   tp = Double(from: ss as! Decoder ) + Double(tt ?? 0.0)
                       self.lblTotalP.text = "$\(self.totalP)"
                        print(self.totalP)
                    }
                }
                DispatchQueue.main.async {
                    self.tblCart.reloadData()
                }
            }else{
                Helper.showSnackBar(with: results["message"] as? String ?? "")
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }

}

extension CartDetailViewController:UITableViewDataSource,UITableViewDelegate{
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = .white
        let cart = cartData[indexPath.row]
        
        if let img = cart.pro_image{
            cell.imgProduct.sd_setImage(with: URL(string: img ), placeholderImage: UIImage(named: ""))
        }
        
        if let proName = cart.pro_title{
            cell.pro_title.text = proName
        }
        if let proQty = cart.quantity{
            cell.quantity.text = proQty
        }
        
        if let regularP = cart.pro_regular_price{
            if let sellP = cart.pro_sale_price{
                if let discount = cart.pro_discount{
                    if let proQty = cart.quantity{
                        if discount == "0"{
                            cell.pro_sale_price.text = "$" + regularP
                            cell.pro_regular_price.isHidden = true
                            cell.pro_sale_price.textColor = #colorLiteral(red: 0.4236943424, green: 0.2528171539, blue: 0.7804867029, alpha: 1)
                            cell.lblLine.isHidden = true
                            
                        }else{
                            cell.pro_regular_price.isHidden = false
                            cell.pro_sale_price.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
                            cell.pro_sale_price.text = "$" + regularP
                            cell.pro_regular_price.text = "$" + sellP
                            cell.lblLine.isHidden = false
                            
                        }
                    }
                }
            }
        }
        
        cell.btnAddQty.tag = indexPath.item
        cell.btnAddQty.addTarget(self, action: #selector(self.addfunn(_:)), for: .touchUpInside)
        cell.btnSubtractQty.tag = indexPath.item
        cell.btnSubtractQty.addTarget(self, action: #selector(self.subtractfunn(_:)), for: .touchUpInside)
        
        cell.btnDelete.tag = indexPath.item
        cell.btnDelete.addTarget(self, action: #selector(self.deleteProduct(_:)), for: .touchUpInside)
        return cell
    }
    
    
    @objc func deleteProduct(_ sender: UIButton) {
        
        HUD.show(.labeledProgress(title: "", subtitle: "Getting products for you..."))
        let userData = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
        
        let params : [String:Any] = ["user_id":"\(userData.user_id ?? "")",
            
            "product_id":"\(cartData[sender.tag].pro_id ?? "")",
            "variation_id":"0"
            ]
        
        service.getResponseFromServerByPostMethod(parametrs: params, url: "remove_cart.php?") { (results) in
            
            let status = results["status"] as? String ?? ""
            if status == "1"{
                HUD.hide()
                Helper.showSnackBar(with: results["message"] as? String ?? "")
                DispatchQueue.main.async {
                    self.cartDetail()
                }
            }else{
                HUD.hide()
                Helper.showSnackBar(with: results["message"] as? String ?? "")
            }
        }
    }
    
    @objc func checkOut(){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CheckoutViewController") as! CheckoutViewController
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    
    @objc func addfunn(_ sender: UIButton) {
        
        if let qnty = cartData[sender.tag].quantity{
            
            guard var qanty = Int(qnty) else { return  }
            
            if qanty >= 1 {
                
                qanty = qanty + 1
                HUD.show(.labeledProgress(title: "", subtitle: "Getting products for you..."))
                let userData = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
                
                let params : [String:Any] = ["user_id":"\(userData.user_id ?? "")",
                    
                    "product_id":"\(cartData[sender.tag].pro_id ?? "")",
                    "variation_id":"0",
                    "qty":"\(qanty)"]
                
                service.getResponseFromServerByPostMethod(parametrs: params, url: "update_cart.php?") { (results) in
                    
                    let status = results["status"] as? String ?? ""
                    if status == "1"{
                        HUD.hide()
                        Helper.showSnackBar(with: results["message"] as? String ?? "")
                        
                        DispatchQueue.main.async {
                            self.cartDetail()
                        }
                    }else{
                        HUD.hide()
                        Helper.showSnackBar(with: results["message"] as? String ?? "")
                    }
                }
            }
        }
    }
    
    @objc func subtractfunn(_ sender: UIButton) {
        if let qnty = cartData[sender.tag].quantity{
            
            guard var qanty = Int(qnty) else { return  }
            
            if qanty > 1 {
                
                qanty = qanty - 1
                HUD.show(.labeledProgress(title: "", subtitle: "Getting products for you..."))
                let userData = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
                
                let params : [String:Any] = ["user_id":"\(userData.user_id ?? "")",
                    
                    "product_id":"\(cartData[sender.tag].pro_id ?? "")",
                    "variation_id":"0",
                    "qty":"\(qanty)"]
                
                service.getResponseFromServerByPostMethod(parametrs: params, url: "update_cart.php?") { (results) in
                    
                    let status = results["status"] as? String ?? ""
                    if status == "1"{
                        HUD.hide()
                        Helper.showSnackBar(with: results["message"] as? String ?? "")
                        
                        
                        DispatchQueue.main.async {
                            
                            self.cartDetail()
                            
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
