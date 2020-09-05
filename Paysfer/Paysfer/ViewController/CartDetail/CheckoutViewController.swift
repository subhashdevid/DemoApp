//
//  CheckoutViewController.swift
//  Paysfer
//
//  Created by SUBHASH KUMAR on 25/08/20.
//  Copyright © 2020 VISHAL VERMA. All rights reserved.
//

import UIKit


import PKHUD



class CheckoutViewController: UIViewController {
    
  
    @IBOutlet weak var tblCart: UITableView!
   

    let service = ServerHandler()
    var cartData = [CartModel]()
    var totalP:Double = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.tblCart.backgroundColor = .white
        
        self.tblCart.register(UINib.init(nibName: "CartTableViewCell", bundle: nil), forCellReuseIdentifier: CartTableViewCell.reuseId)
        self.tblCart.register(UINib.init(nibName: "CheckoutTableViewCell", bundle: nil), forCellReuseIdentifier: CheckoutTableViewCell.reuseId)
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

extension CheckoutViewController:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return cartData.count
        }else{
            if cartData.count>0{
                  return 1
            }else{
                  return 0
            }
          
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{

            let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell", for: indexPath) as! CartTableViewCell
            cell.selectionStyle = .none
            
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
            
            cell.btnAddQty.isHidden = true
            cell.btnSubtractQty.isHidden = true
            cell.btnDelete.isHidden = true
            
            cell.btnAddQty.isUserInteractionEnabled = false
            cell.btnSubtractQty.isUserInteractionEnabled = false
            cell.btnDelete.isUserInteractionEnabled = false
            
            
            
            
            
           
          
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckoutTableViewCell", for: indexPath) as! CheckoutTableViewCell
            
            cell.addressBtn.addTarget(self, action: #selector(getAddressFromList), for: .touchUpInside)
            cell.totalPriceLbl.text = "$\(self.totalP)"
            return cell
        }
    }
    
    
    
    
    @objc func getAddressFromList(){
         let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
               let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddressViewC") as! AddressViewC
               self.tabBarController?.tabBar.isHidden = true
               self.navigationController?.pushViewController(nextViewController, animated: true)
              
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
