//
//  MyOrderViewC.swift
//  Paysfer
//
//  Created by VISHAL VERMA on 23/06/20.
//  Copyright © 2020 VISHAL VERMA. All rights reserved.
//

import UIKit
import PKHUD


class MyOrderViewC: UIViewController {
    
    @IBOutlet weak var lblCart: UILabel!
    
let service = ServerHandler()

    override func viewDidLoad() {
        super.viewDidLoad()
        Helper.cornerCircle(lblCart)
        homeProductData()
        // Do any additional setup after loading the view.
    }
    
     override func viewDidAppear(_ animated: Bool) {
           homeProductData()
           
           
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
    
    
    @IBAction func cartDetailsScreen(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CartDetailViewController") as! CartDetailViewController
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
           return .lightContent
       }
}
