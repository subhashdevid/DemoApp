//
//  SignUpViewC.swift
//  Paysfer
//
//  Created by VISHAL VERMA on 10/06/20.
//  Copyright © 2020 VISHAL VERMA. All rights reserved.
//

import UIKit
import PKHUD

@available(iOS 13.0, *)
class SignUpViewC: UIViewController {
    
    
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPass: UITextField!
    
    let service = ServerHandler()

    

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
    }
  
    @IBAction func backBtnAction(_ sender: Any) {
               self.navigationController?.popViewController(animated: true)
           }
    
    func setUp(){
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        txtUserName.attributedPlaceholder = NSAttributedString(string: "Name",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.label])
        
        txtPhone.attributedPlaceholder = NSAttributedString(string: "Phone",
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.label])
        
        txtEmail.attributedPlaceholder = NSAttributedString(string: "Email Id",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor.label])
        
        txtPassword.attributedPlaceholder = NSAttributedString(string: "Password",
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.label])
        txtConfirmPass.attributedPlaceholder = NSAttributedString(string: "Confirm Password",
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.label])
        
        
    }
 
  @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    @IBAction func facebookAction(_ sender: UIButton) {
        
       }
    @IBAction func googleAction(_ sender: UIButton) {
        
       }
    
    
    @IBAction func signUpAction(_ sender: UIButton) {
        signUp()
    }
    
    
    
    func signUp(){
        
        if (txtUserName.text?.isEmpty)! {
            
            let alertController = UIAlertController(title: "Alert", message: "User Name field can't be empty", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
            
            
        else if (txtEmail.text?.isEmpty)! {
            let alertController = UIAlertController(title: "Alert", message: "Email field can't be empty", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
            
        else if (Helper.validateEmail(with: txtEmail.text!) == false) {
            let alertController = UIAlertController(title: "Alert", message: "Invalid email address", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
            
        else if (txtPassword.text?.isEmpty)! {
            
            let alertController = UIAlertController(title: "Alert", message: "Password field can't be empty", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
            }
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
            
        else if (txtConfirmPass.text?.isEmpty)! {
            
            let alertController = UIAlertController(title: "Alert", message: "Confirm Password field can't be empty", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
            }
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
            
        else if (txtPhone.text?.isEmpty)! {
            
            let alertController = UIAlertController(title: "Alert", message: "Mobile number can't be empty", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
            }
            
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
            
            return
            
            
        }
        else if ((txtPhone.text?.count)!<6) {
            
            let alertController = UIAlertController(title: "Alert", message: "Please input a valid mobile number", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
            }
            
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
            
            return
            
            
        }
            
        else if txtPassword.text != txtConfirmPass.text{
            let alertController = UIAlertController(title: "Alert", message: "Password and Confirm password are not match", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
            }
            
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
            
        else{
            
            
            
            
            let params : [String:Any] = ["name":"\(txtUserName.text!)",
                
                "email":"\(txtEmail.text!)",
                "mobile":"\(txtPhone.text!)",
                "password":"\(txtPassword.text!)"]
            
            HUD.show(.labeledProgress(title: "", subtitle: "Signing..."))
            service.getResponseFromServerByPostMethod(parametrs: params, url: "register.php?") { (results) in
                
                let status = results["status"] as? String ?? ""
                if status == "1"{
                    HUD.hide()
                    let alertController = UIAlertController(title: "Registered", message: results["message"] as? String ?? "", preferredStyle: .alert)
                    
                    let cancelAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel) {
                        UIAlertAction in
                        
                        
                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                        for aViewController in viewControllers {
                            if aViewController is LoginViewController {
                                self.navigationController!.popToViewController(aViewController, animated: true)
                            }
                        }
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
    
    
    
    
    @IBAction func loginAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)

      }
    
    
    
}
