//
//  ProfileViewC.swift
//  Paysfer
//
//  Created by VISHAL VERMA on 07/07/20.
//  Copyright © 2020 VISHAL VERMA. All rights reserved.
//

import UIKit
import PKHUD

class ProfileViewC: UIViewController {
     @IBOutlet weak var profileTableView: UITableView!
    
    @IBOutlet weak var imgUserProfile: UIImageView!
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var hideBtn: UIButton!
    @IBOutlet weak var txtoldPass: UITextField!
    @IBOutlet weak var txtNewPass: UITextField!
    @IBOutlet weak var txtConfirmPass: UITextField!
    @IBOutlet weak var changePassVw: UIView!
    
    
    var userData : userModel?
    let service = ServerHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userDetails()
        self.profileTableView.backgroundColor = .white
        Helper.cornerCircle(imgUserProfile)
        
        userData = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
        txtFullName.text = userData?.user_name ?? ""
        lblEmail.text = userData?.user_email  ?? ""
        txtPhone.text = userData?.user_mob ?? ""
        
        
        //  if let img = userData?.user_img{
        imgUserProfile.sd_setImage(with: URL(string: UserDefaults.standard.getProfileImg() ?? ""), placeholderImage: UIImage(named: "user_image"))
        // }
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func hidebackbtnAction(_ sender: UIButton) {
        
        self.hideBtn.isHidden = true
        self.changePassVw.isHidden = true
        
        
    }
    
    
    @IBAction func changePassActionBtn(_ sender: UIButton) {
        
        self.hideBtn.isHidden = false
        self.changePassVw.isHidden = false
        
    }
    
    
    @IBAction func saveChangePassAction(_ sender: UIButton) {
        
       changePass()
        
    }
    
    func changePass(){
        
        if (txtoldPass.text?.isEmpty)! {
            Helper.showSnackBar(with: "Name field can't be empty")
            return
        }
        else if (txtNewPass.text?.isEmpty)! {
            Helper.showSnackBar(with: "Please select your phone number")
            return
        }
        else if (txtConfirmPass.text?.isEmpty)! {
            Helper.showSnackBar(with: "Please select your address")
            return
        }
            
        else if (txtNewPass.text != txtConfirmPass.text) {
            Helper.showSnackBar(with: "New password and confirm password does not match")
            return
        }
            
            
        else{
            
            
            
            
            let userId = UserDefaults.standard.value(forKey: "uid") as? String
            
            let params : [String:Any] = ["user_id": userId ?? "",
                                         "old_pass": txtoldPass.text ?? "",
                                         "new_pass": txtNewPass.text ?? ""
            ]
            
            HUD.show(.labeledProgress(title: "", subtitle: "Loading..."))

            
            service.getResponseFromServerByPostMethod(parametrs: params, url: "change_password.php?") { (results) in
                
                let status = results["status"] as? String ?? ""
                if status == "1"{
                    HUD.hide()
                    
                    print(status)
                    //UserDefaults.standard.setUserDetails(value: results["data"] as! [String : Any])
                    let alertController = UIAlertController(title: "Success", message: results["message"] as? String ?? "", preferredStyle: .alert)
                    
                    let cancelAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel) {
                        UIAlertAction in
                        
                        self.hideBtn.isHidden = true
                        self.changePassVw.isHidden = true
                        
                    }
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                }else{
                    let alertController = UIAlertController(title: "Failure", message: results["message"] as? String ?? "", preferredStyle: .alert)
                    
                    let cancelAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel) {
                        UIAlertAction in
                        
                        self.hideBtn.isHidden = true
                        self.changePassVw.isHidden = true
                        
                    }
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    
    @IBAction func actionProfileimgBtn(_ sender: UIButton) {
        let actionSheetController: UIAlertController = UIAlertController(title: "Paysfer", message: "Edit profile image", preferredStyle: .actionSheet)
        let photoBtn: UIAlertAction = UIAlertAction(title: "Photo", style: .default) { action -> Void in
            self.selectImageFromGallery()
        }
        let cameraBtn: UIAlertAction = UIAlertAction(title: "Camera", style: .default) { action -> Void in
            self.selectImageFromGallery()
        }
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(photoBtn)
        actionSheetController.addAction(cameraBtn)
        actionSheetController.addAction(cancelAction)
        self.present(actionSheetController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func saveActionBtn(_ sender: UIButton) {
        editUserProfile()
    }
    
    
    func editUserProfile(){
        
        if (txtFullName.text?.isEmpty)! {
            let alertController = UIAlertController(title: "Empty Fullname", message: "Fullname field can't be empty", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
            
            
        else if (txtPhone.text?.isEmpty)! {
            let alertController = UIAlertController(title: "Empty Mobile", message: "Mobile field can't be empty", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        else{
            
            
            let params : [String:Any] = ["user_id": userData?.user_id ?? "",
                                         "mobile": txtPhone.text ?? "",
                                         "name": txtFullName.text ?? ""
            ]
            HUD.show(.labeledProgress(title: "", subtitle: "Saving..."))

            service.getResponseFromServerByPostMethod(parametrs: params, url: "\(profile_edit)") { (results) in
                
                let status = results["status"] as? String ?? ""
                if status == "1"{
                    
                    HUD.hide()
                    
                    print(status)

                    let alertController = UIAlertController(title: "Success", message: results["message"] as? String ?? "", preferredStyle: .alert)
                    
                    let cancelAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel) {
                        UIAlertAction in
                        self.userDetails()
                        
                    }
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                    
                    
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
    }
    
    func userDetails(){
        
        let userId = UserDefaults.standard.value(forKey: "uid") as? String
        
        service.getResponseFromServer(parametrs: "user_details.php?user_id=\(userId ?? "")") { (results) in
            let status = results["status"] as? String ?? ""
            if status == "1"{
                
                print(results["message"] as? String ?? "")
                UserDefaults.standard.setUserDetails(value: results["data"] as! [String : Any])
                
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
}
