//
//  AddressViewC.swift
//  Paysfer
//
//  Created by VISHAL VERMA on 07/07/20.
//  Copyright © 2020 VISHAL VERMA. All rights reserved.
//

import UIKit
import PKHUD




struct addressListModel{
    var address_id:String?
    var first_name:String?
    var last_name:String?
    var mobile:String?
    var company:String?
    var address1:String?
    var address2:String?
    var country:String?
    var state:String?
    var city:String?
    var zipcode:String?
    var defaultSelected:String?
    
    
    init(_ dict: [String: Any]) {
        self.address_id = dict["address_id"] as? String
        self.first_name = dict["first_name"] as? String
        self.last_name = dict["last_name"] as? String
        self.mobile = dict["mobile"] as? String
        self.company = dict["company"] as? String
        self.address1 = dict["address1"] as? String
        self.address2 = dict["address2"] as? String
        self.state = dict["state"] as? String
        self.city = dict["city"] as? String
        self.zipcode = dict["zipcode"] as? String
        self.defaultSelected = dict["default"] as? String
        
    }
}


class AddressViewC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
     let service = ServerHandler()
    
    var addressData = [addressListModel]()
    
    @IBOutlet weak var addressTableView: UITableView!
    let userData = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addressTableView.delegate = self
        self.addressTableView.dataSource = self
        self.addressTableView.backgroundColor = .white
        self.addressTableView.register(UINib.init(nibName: "sectionHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: sectionHeaderTableViewCell.reuseId)
        self.addressTableView.register(UINib.init(nibName: "AddressTableViewCell", bundle: nil), forCellReuseIdentifier: AddressTableViewCell.reuseId)
        
        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getAddresses()
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressData.count
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       // let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: self.addressTableView.frame.size.width, height: 45))
        let headerCell = addressTableView.dequeueReusableCell(withIdentifier: "sectionHeaderTableViewCell") as! sectionHeaderTableViewCell
        
        
        headerCell.cellButton.addTarget(self, action: #selector(addAddressAction), for: .touchUpInside)
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = addressTableView.dequeueReusableCell(withIdentifier: "AddressTableViewCell", for: indexPath) as! AddressTableViewCell
        
        let cellModel = addressData[indexPath.row] as addressListModel
        
        cell.backgroundColor = .white
        cell.cellNamelbl.text = "\(cellModel.first_name ?? "") \(cellModel.last_name ?? "")"
        cell.cellMobileLbl.text = "\(cellModel.mobile ?? "")"
        cell.cellAddress1lbl.text = "\(cellModel.address1 ?? "")"
        cell.cellAddress2lbl.text = "\(cellModel.address2 ?? "")"
        cell.cellCityLbl.text = "\(cellModel.city ?? "") \(cellModel.state) - \(cellModel.zipcode)"
        cell.cellCountryLbl.text = "\(cellModel.country ?? "")"
        
        return cell
    }
    
   
    
    @objc func addAddressAction(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddAddressViewController") as? AddAddressViewController
        vc?.userId = userData.user_id ?? ""
        self.navigationController?.pushViewController(vc!, animated: true)
              
        
    }
    
    
    
    
    
    func getAddresses(){
           HUD.show(.labeledProgress(title: "", subtitle: "Getting your address"))
           
        service.getResponseFromServer(parametrs: "address_list.php?user_id=\(userData.user_id ?? "")") { (results) in
               let status = results["status"] as? String ?? ""
               if status == "1"{
                   HUD.hide()
                   if let quets = results["data"] as? [[String:Any]]{
                       for item in quets{
                           //  print(item)
                           
                           self.addressData.append(addressListModel(item))
                       }
                       
                       DispatchQueue.main.async {
                           self.addressTableView.reloadData()
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
    
}
