//
//  AddAddressViewController.swift
//  Paysfer
//
//  Created by SUBHASH KUMAR on 15/09/20.
//  Copyright © 2020 VISHAL VERMA. All rights reserved.
//

import UIKit
import DropDown
import PKHUD

class AddAddressViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
   
    @IBOutlet weak var addressTblVw: UITableView!
    
    let service = ServerHandler()
    
    
    
    var dropDown = DropDown()
    var firstName = ""
    var lastName = ""
    var phoneNumber = ""
    var homeCompany = ""
    var city = ""
    var address1 = ""
    var address2 = ""
    var zipCode = ""
    var countryName = ""
    var stateName = ""
    
    var stateId = ""
    var countryId = ""
    
    
    var countryArr : Array<CountryModel> = []
    var stateArr : Array<StateModel> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addressTblVw.register(UINib.init(nibName: "AddAddressTableViewCell", bundle: nil), forCellReuseIdentifier: AddAddressTableViewCell.reuseId)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        self.getCountryNames()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
   
    func getCountryNames(){
           let userData = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
           HUD.show(.labeledProgress(title: "", subtitle: "Getting products for you..."))
           
           service.getResponseFromServer(parametrs: "select_country.php") { (results) in
            let model =  CountryListModel.init(results as AnyObject)
            let status = model.status
            
               if status == "1"{
                   HUD.hide()
                self.countryArr = model.countryArr ?? []
                
                self.addressTblVw.reloadData()
               }else{
                   HUD.hide()
                   Helper.showSnackBar(with: results["message"] as? String ?? "")
               }
           }
       }
    
    
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 1
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = addressTblVw.dequeueReusableCell(withIdentifier: "AddAddressTableViewCell", for: indexPath) as! AddAddressTableViewCell
        
        
        cell.firstNameFld.tag = 1
        cell.lastNameFld.tag = 2
        cell.phoneFld.tag = 3
        cell.hNoCompanyFld.tag = 4
        cell.addline1Fld.tag = 5
        cell.addLine2Fld.tag = 6
        cell.cityFld.tag = 7
        cell.zipCodeFld.tag = 8
        
        cell.firstNameFld.delegate = self
        cell.lastNameFld.delegate = self
        cell.phoneFld.delegate = self
        cell.hNoCompanyFld.delegate = self
        cell.addline1Fld.delegate = self
        cell.addLine2Fld.delegate = self
        cell.cityFld.delegate = self
        cell.zipCodeFld.delegate = self
        
        
        cell.countryBtn.addTarget(self, action: #selector(selectCountryFromList), for: .touchUpInside)
        cell.stateBtn.addTarget(self, action: #selector(selectStateFromList), for: .touchUpInside)
        cell.setAsDefaultBtn.addTarget(self, action: #selector(selectCheckBox), for: .touchUpInside)
               
        if !(self.countryName.isEmpty){
             cell.countryFld.text = self.countryName
        }
       if !(self.stateName.isEmpty){
            cell.stateFld.text = self.stateName
       }
        
        
        return cell
        
        
        
    }

    
    func textFieldDidBeginEditing(_ textField: UITextField) {    //delegate method

        if textField.tag == 1{
            self.firstName = textField.text!
            
        }else if textField.tag == 2{
             self.lastName = textField.text!
            
        }else if textField.tag == 3{
            self.phoneNumber = textField.text!
        }else if textField.tag == 4{
            self.phoneNumber = textField.text!
        }else if textField.tag == 5{
            self.homeCompany = textField.text!
        }else if textField.tag == 6{
             self.address1 = textField.text!
        }else if textField.tag == 7{
            self.address2 = textField.text!
        }
        else if textField.tag == 8{
            self.zipCode = textField.text!
        }
        
         self.addressTblVw.reloadData()
    }
    
    
    @objc func selectCountryFromList(_ sender :UIButton){
        
        var countryArray : Array<String> = []
        
        for item in self.countryArr {
            countryArray.append(item.countryName)
        }
        
        self.dropDown.anchorView = sender.plainView
        self.dropDown.bottomOffset = CGPoint(x: 0, y: (sender).bounds.height)
        self.dropDown.dataSource.removeAll()
        self.dropDown.dataSource = countryArray
        self.dropDown.contentMode = .center
        self.dropDown.selectionAction = { [unowned self] (index,item) in
            self.countryName = item
            let countryId = (self.countryArr[index] as CountryModel).countryId
            self.getStatesNames(countryId)
             self.addressTblVw.reloadData()
        }
        self.dropDown.show()
    }
    
    
    func getStatesNames(_ countryId : String){
         
           
             HUD.show(.labeledProgress(title: "", subtitle: "Getting products for you..."))
           
             
             let params : [String:Any] = ["country_id": countryId]
             
             service.getResponseFromServerByPostMethod(parametrs: params, url: "select_state.php?") { (results) in
                  let model =  StateListModel.init(results as AnyObject)
                let status = model.status
                 if status == "1"{
                     HUD.hide()
                     Helper.showSnackBar(with:  model.message)
                   
                    self.stateArr = model.stateArr
                    
                         
                   self.addressTblVw.reloadData()
                     
                     
                 }else{
                     HUD.hide()
                     Helper.showSnackBar(with: results["message"] as? String ?? "")
                 }
             
        }
       }
    
    
    @objc func selectStateFromList(_ sender :UIButton){
      
       
        
        var stateArray : Array<String> = []
               
               for item in self.stateArr {
                   stateArray.append(item.stateName)
               }
        
        
        self.dropDown.anchorView = sender.plainView
        self.dropDown.bottomOffset = CGPoint(x: 0, y: (sender).bounds.height)
        self.dropDown.dataSource.removeAll()
        self.dropDown.dataSource = stateArray
        self.dropDown.contentMode = .center
        self.dropDown.selectionAction = { [unowned self] (index,item) in
            
            self.stateName = item
            self.stateId = (self.stateArr[index] as StateModel).stateId
             self.addressTblVw.reloadData()
        }
         self.dropDown.show()
    }
    @objc func selectCheckBox(_ sender :UIButton){
        
    }
}





class CountryListModel: NSObject {
    
    var status = ""
    var message = ""
    var countryArr : Array<CountryModel> = []
    
    convenience init(_ response:AnyObject) {
        self.init()
        
        self.status = response["status"] as? String ?? ""
        self.message = response["message"] as? String ?? ""
        
        let data = response["data"] as? Array<Dictionary<String,AnyObject>> ?? []
        
        for item in data{
            self.countryArr.append(CountryModel(item as AnyObject))
        }
    }
    
    
}
class CountryModel: NSObject {
    
    var countryId = ""
    var countryName = ""
    
    convenience init(_ response:AnyObject) {
        self.init()
        
        self.countryId = response["id"] as? String ?? ""
        self.countryName = response["name"] as? String ?? ""
        
    }
    
    
}

class StateListModel: NSObject {
    
    var status = ""
    var message = ""
    var stateArr : Array<StateModel> = []
    
    convenience init(_ response:AnyObject) {
        self.init()
        
        self.status = response["status"] as? String ?? ""
        self.message = response["message"] as? String ?? ""
        
        let data = response["data"] as? Array<Dictionary<String,AnyObject>> ?? []
        
        for item in data{
            self.stateArr.append(StateModel(item as AnyObject))
        }
    }
    
    
}
class StateModel: NSObject {
    
    var stateId = ""
    var stateName = ""
    
    convenience init(_ response:AnyObject) {
        self.init()
        
        self.stateId = response["id"] as? String ?? ""
        self.stateName = response["name"] as? String ?? ""
        
    }
    
    
}
