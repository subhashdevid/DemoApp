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
    var isCellSeleced : Bool = false
    var sectionSelected = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        tblSlide.layer.shadowColor = UIColor.black.cgColor
        tblSlide.layer.shadowOffset = CGSize(width: 110.0, height: 115.0)
        tblSlide.layer.shadowRadius = 115
        tblSlide.layer.shadowOpacity = 1
        
       
        self.tblSlide.register(UINib.init(nibName: "SlidemenuCell", bundle: nil), forCellReuseIdentifier: SlidemenuCell.reuseId)
        
        guard let menu = navigationController as? SideMenuNavigationController, menu.blurEffectStyle == nil else {
            return
        }
        
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            // Reference - https://stackoverflow.com/a/57899013/7316675
            let statusBar = UIView(frame: window?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
            statusBar.backgroundColor = Colors().navigationColor
            window?.addSubview(statusBar)
        } else {
            let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
            statusBar.backgroundColor = Colors().navigationColor
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let quets = UserDefaults.standard.getSetSideMenuListIn() as Array<Dictionary<String,AnyObject>>
        
        if quets.count>0{
             self.categoryData = []
            for item in quets{
                self.categoryData.append(CategoryModel(item))
            }
        }
        
        if !(self.categoryData.count>0){
            self.categoryApi()
        }
        
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
                    if (quets.count)>0{
                        UserDefaults.standard.setSetSideMenuListIn(detailList: quets as Array<Dictionary<String, AnyObject>>)
                        UserDefaults.standard.synchronize()
                    }
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
        return categoryData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let secRowArr = categoryData[section].s_cat
        return secRowArr.count
    }

    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        tableView.register(UINib(nibName: "CustomViewHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomViewHeaderTableViewCell")
        let headerView = tableView.dequeueReusableCell(withIdentifier: "CustomViewHeaderTableViewCell" ) as! CustomViewHeaderTableViewCell

        headerView.cellLabel.text = "  \(categoryData[section].cat_name ?? "")"
        headerView.cellButton.tag = section
        
        
        headerView.cellButton.addTarget(self, action: #selector(manageSection), for: .touchUpInside)
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SlidemenuCell", for: indexPath) as! SlidemenuCell
        cell.selectionStyle = .none
        
        let cellModel = categoryData[indexPath.section].s_cat
        cell.cellLabel.text = "\(cellModel[indexPath.row].sub_name ?? "")"
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let secRowArr = categoryData[indexPath.section].s_cat
        if secRowArr.count>0{
            guard let p_Id : Int = secRowArr[indexPath.row].sub_id else{ return }
            guard let catName : String = secRowArr[indexPath.row].sub_name else{ return }
            self.categorySelected(catName: catName, p_id: p_Id)
        }
        
    }
    
    
    
    func categorySelected(catName:String,p_id:Int) -> Void {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
               let nextViewController = storyBoard.instantiateViewController(withIdentifier: "CategoryDetailViewC") as! CategoryDetailViewC
               
             
               
               nextViewController.heading = catName
               
               nextViewController.cat_id = "\(p_id)"
            //    nextViewController.lblHeading.text = categoryData[indexPath.row].cat_name
               self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if isCellSeleced == true && sectionSelected == indexPath.section{
            return 60
        }else{
            return 0
        }
       
        
    }
    
    
    @objc func manageSection(_ sender : UIButton) -> Void {
        let secRowArr = categoryData[sender.tag].s_cat
        if secRowArr.count>0{
            isCellSeleced = !isCellSeleced
            sectionSelected = sender.tag
            self.tblSlide.reloadData()
        }else{
            guard let p_Id : Int = categoryData[sender.tag].cat_id else{ return }
            guard let catName : String = categoryData[sender.tag].cat_name else{ return }
            self.categorySelected(catName: catName, p_id: p_Id)
        }
    }
    
    
    @objc func btnAction(_ sender: UIButton){
        
    }
    
    
    
    
}
