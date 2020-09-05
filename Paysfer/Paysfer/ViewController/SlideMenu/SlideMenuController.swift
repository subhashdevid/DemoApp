//
//  SlideMenuController.swift
//  Paysfer
//
//  Created by VISHAL VERMA on 18/06/20.
//  Copyright © 2020 VISHAL VERMA. All rights reserved.
//

import UIKit
import SideMenu

@available(iOS 13.0, *)
class SlideMenuController: UITableViewController {
    
    @IBOutlet weak var tblSlide: UITableView!
    @IBOutlet weak var lblHeading: UILabel!
    
    
    let service = ServerHandler()
    var categoryData = [CategoryModel]()
    var userData : userModel?
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let myarray = UserDefaults.standard.array(forKey: "SavedStringArray") as? [String]{
//            self.categoryData = myarray
//
//        }

        tblSlide.reloadData()
        
        categoryApi()
        
        tblSlide.layer.shadowColor = UIColor.black.cgColor
        tblSlide.layer.shadowOffset = CGSize(width: 110.0, height: 115.0)
        tblSlide.layer.shadowRadius = 115
        tblSlide.layer.shadowOpacity = 1
        
        // self.tblSlide.register(UINib.init(nibName: "MenuCell", bundle: nil), forCellReuseIdentifier: MenuCell.reuseId)
        self.tblSlide.register(UINib.init(nibName: "SlidemenuCell", bundle: nil), forCellReuseIdentifier: SlidemenuCell.reuseId)
        
        guard let menu = navigationController as? SideMenuNavigationController, menu.blurEffectStyle == nil else {
            return
        }
        
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            // Reference - https://stackoverflow.com/a/57899013/7316675
            let statusBar = UIView(frame: window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
            statusBar.backgroundColor = #colorLiteral(red: 0.4236943424, green: 0.2528171539, blue: 0.7804867029, alpha: 1)
            window?.addSubview(statusBar)
        } else {
            let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
            statusBar.backgroundColor = #colorLiteral(red: 0.4236943424, green: 0.2528171539, blue: 0.7804867029, alpha: 1)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.isLoggedIn() {
            
            userData = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
            
            
            lblHeading.text = "My Account/logout"
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        
        if UserDefaults.standard.isLoggedIn(){
            
            let root = self.storyboard?.instantiateViewController(withIdentifier: "AccountViewC") as? AccountViewC
            root?.headerChange = "2"
            
            self.navigationController?.pushViewController(root ?? UIViewController(), animated: true)
            
        }else{
            lblHeading.text = "SignIn/SignUp"
            
            let root = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
            self.navigationController?.pushViewController(root ?? UIViewController(), animated: true)
        }
        
    }
    
    
    // MARK: - Table view data source
    
    
    func categoryApi(){
        
        // let StateId = UserDefaults.standard.value(forKey: "StateId") as? String ?? ""
        service.getResponseFromServer(parametrs: "demo_category.php?category=category") { (results) in
            let status = results["status"] as? String ?? ""
            if status == "1"{
                
                if let quets = results["data"] as? [[String:Any]]{
                    for item in quets{
                          print(item)
                        self.categoryData.append(CategoryModel(item))
                    }
                    DispatchQueue.main.async {
                        self.tblSlide.reloadData()
                    }
                }
            }else{
                let alertController = UIAlertController(title: "Failure", message: results["message"] as? String ?? "", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel) {
                    UIAlertAction in
                }
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryData.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SlidemenuCell", for: indexPath) as! SlidemenuCell
        cell.selectionStyle = .none
        cell.textLabel?.text = categoryData[indexPath.row].cat_name
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CategoryDetailViewC") as! CategoryDetailViewC
        
        guard let p_Id = categoryData[indexPath.row].cat_id else{ return }
        guard let catName = categoryData[indexPath.row].cat_name else{ return }
        
        nextViewController.heading = catName
        
        nextViewController.cat_id = "\(p_Id)"
     //    nextViewController.lblHeading.text = categoryData[indexPath.row].cat_name
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    
    @objc func btnAction(_ sender: UIButton){
        
    }
    
}
