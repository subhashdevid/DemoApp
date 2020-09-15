//
//  AccountViewC.swift
//  Paysfer
//
//  Created by VISHAL VERMA on 23/06/20.
//  Copyright © 2020 VISHAL VERMA. All rights reserved.
//

import UIKit
import SideMenu
import PKHUD

@available(iOS 13.0, *)
class AccountViewC: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    
    
  
    @IBOutlet weak var menuBackBtn: UIButton!
    @IBOutlet weak var imgHeader: UIImageView!
    @IBOutlet weak var lblCart: UILabel!
    
    @IBOutlet weak var accountsTblView: UITableView!

    let service = ServerHandler()
    var userData : userModel?
    var headerChange = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.accountsTblView.backgroundColor = .white
        self.accountsTblView.register(UINib.init(nibName: "AccountsTableViewCell", bundle: nil), forCellReuseIdentifier: AccountsTableViewCell.reuseId)
       
        Helper.cornerCircle(lblCart)
        homeProductData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
           homeProductData()
           
           
       }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false

        
        if UserDefaults.standard.isLoggedIn() {
            
            SideMenuManager.default.addPanGestureToPresent(toView: self.navigationController!.navigationBar)
            
            userData = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
            
            if headerChange == "1"{
                self.imgHeader.image = #imageLiteral(resourceName: "open-menu")
                self.menuBackBtn.addTarget(self, action: #selector(menuAction), for: .touchUpInside)
            }else{
                self.imgHeader.image = #imageLiteral(resourceName: "arrow")
                self.menuBackBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
            }
        }
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
                HUD.hide()
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
    
    @objc func menuAction(){
        let menu = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! SideMenuNavigationController
        present(menu, animated: true, completion: nil)
    }
    
    @objc func backAction(){
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    
    
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 1
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountsTableViewCell", for: indexPath) as! AccountsTableViewCell
               cell.selectionStyle = .none
        
        cell.imgUser.sd_setImage(with: URL(string: UserDefaults.standard.getProfileImg() ?? ""), placeholderImage: UIImage(named: "user_image"))
        
        if let userName = userData?.user_name {
            cell.lblName.text = userName
        }
         cell.editImageBtn.addTarget(self, action: #selector(imgUserAction), for: .touchUpInside)
        cell.editProfileBtn.addTarget(self, action: #selector(editProfileAction), for: .touchUpInside)
        cell.editAddressBtn.addTarget(self, action: #selector(addressAction), for: .touchUpInside)
        cell.contactUsBtn.addTarget(self, action: #selector(contactAction), for: .touchUpInside)
        cell.privacyPolicyBtn.addTarget(self, action: #selector(provacyPolicyAction), for: .touchUpInside)
        cell.termsConditionBtn.addTarget(self, action: #selector(termsConditionAction), for: .touchUpInside)
        cell.logOutBtn.addTarget(self, action: #selector(logoutAction), for: .touchUpInside)
        return cell
        
        
       }
    
    
    @objc func editProfileAction(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewC") as? ProfileViewC
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    @objc func addressAction(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddressViewC") as? AddressViewC
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
   @objc func contactAction(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsViewC") as? ContactUsViewC
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
   @objc func provacyPolicyAction(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PrivacyPolicyViewC") as? PrivacyPolicyViewC
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
   @objc func termsConditionAction(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TermsandConditionViewC") as? TermsandConditionViewC
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
   @objc  func logoutAction(_ sender: UIButton) {
        logoutFunction()
    }
  @objc  func imgUserAction(_ sender: UIButton) {
        
    }
    
    
    func logoutFunction() {
        
        
        let alertController = UIAlertController(title: "Logout", message: "Do you really want to log out", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            UIAlertAction in
            
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.sideMenuList.rawValue)
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.userdetails.rawValue)
            
            let login = self.storyboard?.instantiateViewController(withIdentifier: "TabbarViewController")
            self.navigationController?.pushViewController(login!, animated: true)
            
            
        }
        
        let noAction = UIAlertAction(title: "No", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            
        }
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        return
        
    }
}
