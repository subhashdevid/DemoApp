//
//  ViewController.swift
//  Paysfer
//
//  Created by VISHAL VERMA on 04/06/20.
//  Copyright © 2020 VISHAL VERMA. All rights reserved.
//

import UIKit
import PKHUD
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth
import AuthenticationServices



@available(iOS 13.0, *)
class LoginViewController: UIViewController,GIDSignInDelegate,ASAuthorizationControllerDelegate {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    
    @IBOutlet weak var hideBtn: UIButton!
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var googleSignInBtn: UIButton!
    //    @IBOutlet weak var faceBookLoginView: FBLoginButton!
    @IBOutlet weak var faceBookLoginBtn: UIButton!
    @IBOutlet weak var appleLoginBtnVw: UIView!
    
    
   
    
    let service = ServerHandler()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpSignInAppleButton()
        
    }
    
    
    
    func setUp(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func forgotAction(_ sender: UIButton) {
        self.hideBtn.isHidden = false
        
    }
    
    @IBAction func hidebackbtnAction(_ sender: UIButton) {
        
        self.hideBtn.isHidden = true
        
        
    }
    
    
    @IBAction func confirmbtnAction(_ sender: UIButton) {
        if (txtEmail.text?.isEmpty)! {
            Helper.showSnackBar(with: "Email field can't be empty")
            return
        }
            
        else if (Helper.validateEmail(with: txtEmail.text!) == false) {
            Helper.showSnackBar(with: "Invalid email address")
            return
        }
            
        else{
            //http://demo12.mediatrenz.com/InterfaceSERVICES/Api/v1/forgot_pass.php
            
            let params : [String:Any] = ["email":"\(txtEmail.text!)"]
            
            HUD.show(.labeledProgress(title: "", subtitle: "Loading..."))
            
            service.getResponseFromServerByPostMethod(parametrs: params, url: "forgot_password.php?") { (results) in
                
                let status = results["status"] as? String ?? ""
                if status == "1"{
                    HUD.hide()
                    let alertController = UIAlertController(title: "Success", message: results["message"] as? String ?? "", preferredStyle: .alert)
                    
                    let cancelAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel) {
                        UIAlertAction in
                        
                        self.hideBtn.isHidden = true
                        
                        
                    }
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                }else{
                    HUD.hide()
                    let alertController = UIAlertController(title: "Failure", message: results["message"] as? String ?? "", preferredStyle: .alert)
                    
                    let cancelAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel) {
                        UIAlertAction in
                        
                        self.hideBtn.isHidden = true
                        
                        
                    }
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    
    @IBAction func loginAction(_ sender: UIButton) {
        loginAccount()
    }
    
    
    @IBAction func loginByGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
        
    }
    
 
 //MARK:- Apple SignIn
//    func setUpSignInAppleButton() {
//
//    }
//    
    
    func setUpSignInAppleButton() {
      let authorizationButton = ASAuthorizationAppleIDButton()
      authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
        
        authorizationButton.frame = self.appleLoginBtnVw.bounds
      //authorizationButton.cornerRadius = 10
      //Add button on some view or stack
      self.appleLoginBtnVw.addSubview(authorizationButton)
    }

    
    @objc func handleAppleIdRequest() {
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]
    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.performRequests()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
    let userIdentifier = appleIDCredential.user  ?? ""
        let firstName = appleIDCredential.fullName?.givenName ?? ""
        let LastName = appleIDCredential.fullName?.familyName  ?? ""
        let fullName = "\(firstName) \(LastName)"
    let email = appleIDCredential.email ?? ""
        
        let userUid = userIdentifier
        let userName = fullName
        let userEmail = email
        
       let dict : [String:AnyObject] = ["user_name":userName as AnyObject,"user_email": userEmail as AnyObject,"oauth_uid":userUid as AnyObject,"oauth_provider":"apple" as AnyObject]
        
        UserDefaults().setUserDetails(value: dict)
        UserDefaults().synchronize()
        
        self.signInWithSocialMediaAccount(dict)
        
    print("User id is \(userIdentifier) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))") }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    }



    
  
    //MARK:- Google Delegate
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {

    }

    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }

    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
                     withError error: Error!) {
        if (error == nil) {
            
            
                      // Perform any operations on signed in user here.
                      let userUid = user.userID                  // For client-side use only!
                      //let Id = user.authentication.idToken // Safe to send to the server
                      let userName = user.profile.name
                      let userEmail = user.profile.email
print(userUid,userName,userEmail)
            
            if user.userID != nil {
                 print("Login Successful.")
                //let userUid = user.userID ?? ""
               // let userName = user.userID ?? ""
               // let userEmail = userModel?.email ?? ""
                
            let dict : [String:AnyObject] = ["user_name":userName as AnyObject,"user_email": userEmail as AnyObject,"oauth_uid":userUid as AnyObject,"oauth_provider":"google" as AnyObject]
             UserDefaults().setUserDetails(value: dict)
             UserDefaults().synchronize()
                
            self.signInWithSocialMediaAccount(dict)
                
            } else {
                print("Login failure.")
                
            }
            
            // ...
        } else {
            print("\(error)")
        }
    }
    //MARK:- Facebook Delegate
    @IBAction func faceBookLoginButtonTapped(_ sender: UIButton) {
        
        let loginManager = LoginManager()
        if let _ = AccessToken.current {
            loginManager.logOut()
        } else {
            loginManager.logIn(permissions: ["email"], from: self) { [weak self] (result, error) in
                
             
                
                guard let accessToken = FBSDKLoginKit.AccessToken.current else { return }
                let graphRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                              parameters: ["fields": "email, name"],
                                                              tokenString: accessToken.tokenString,
                                                              version: nil,
                                                              httpMethod: .get)
                graphRequest.start { (connection, result, error) -> Void in
                    if error != nil {
                        print("error \(error)")
                    }
                    else {
                        
                        let resultDict = result as? Dictionary<String,AnyObject> ?? [:]
                        
                        
                        let userUid = resultDict["id"] as? String ?? ""
                        let userName = resultDict["name"] as? String ?? ""
                        let userEmail = resultDict["email"] as? String ?? ""
                        
                        let dict : [String:AnyObject] = ["user_name":userName as AnyObject,"user_email": userEmail as AnyObject,"oauth_uid":userUid as AnyObject,"oauth_provider":"facebook" as AnyObject]
                        
                        UserDefaults().setUserDetails(value: dict)
                         UserDefaults().synchronize()
                        
                        self?.signInWithSocialMediaAccount(dict)
                    }
                }
                
                
                
            }
        }
    }
    
    
    
    
    
    @objc func signInWithSocialMediaAccount(_ dict:[String:AnyObject]){
       //http://demo12.mediatrenz.com/InterfaceSERVICES/Api/v1/forgot_pass.php
       
       let params : [String:AnyObject] = dict
       
       HUD.show(.labeledProgress(title: "", subtitle: "Loading..."))
      
        service.getResponseFromServerByPostMethod(parametrs: params, url: "facebook_login.php?") { (results) in
                      
              
           let status = results["status"] as? String ?? ""
           if status == "1"{
               HUD.hide()
               let data = results["data"] as! [String:Any]
               UserDefaults.standard.setUserDetails(value: data)
               
               
               let userData = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
               print(userData)
               
               let token = data["user_id"] as! String
               
               UserDefaults.standard.set(token, forKey: "uid")
               // let token = Helper.
               UserDefaults.standard.setLoggedIn(value: true)
               
               
               let login = self.storyboard?.instantiateViewController(withIdentifier: "TabbarViewController")
               self.navigationController?.pushViewController(login!, animated: true)
           }else{
               HUD.hide()
               let alertController = UIAlertController(title: "Failure", message: results["message"] as? String ?? "", preferredStyle: .alert)
               
               let cancelAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel) {
                   UIAlertAction in
                   
                   self.hideBtn.isHidden = true
                  
                   
               }
               alertController.addAction(cancelAction)
               self.present(alertController, animated: true, completion: nil)
           }
       }
   }
    
    
  
    
    
    
    @IBAction func signUpAction(_ sender: UIButton) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SignUpViewC") as! SignUpViewC
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    
    
    
    
    
    func loginAccount(){
        
        if (txtName.text?.isEmpty)! {
            let alertController = UIAlertController(title: "Empty email", message: "Email field can't be empty", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
            }
            
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
            
        else if (Helper.validateEmail(with: txtName.text!) == false){
            
            
            
            let alertController = UIAlertController(title: "Invalid email address", message: "The email address you entered is incorrect. Please try again", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
                NSLog("Cancel Pressed")
            }
            
            
            // Add the actions
            alertController.addAction(cancelAction)
            
            
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
            
            // Helper.showSnackBar(with: "Invalid email address")
            return
        }
            
        else if (txtPassword.text?.isEmpty)! {
            
            let alertController = UIAlertController(title: "Empty password", message: "Password field can't be empty", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel) {
                UIAlertAction in
            }
            
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        HUD.show(.labeledProgress(title: "", subtitle: "Signing..."))
        
        
        
        service.getResponseFromServer(parametrs: "log.php?email=\(txtName.text!)&&password=\(txtPassword.text!)") { (results) in
            let status = results["status"] as? String ?? ""
            if status == "1"{
                HUD.hide()
                let data = results["data"] as! [String:Any]
                UserDefaults.standard.setUserDetails(value: data)
                
                
                let userData = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
                print(userData)
                
                let token = data["user_id"] as! String
                
                UserDefaults.standard.set(token, forKey: "uid")
                // let token = Helper.
                UserDefaults.standard.setLoggedIn(value: true)
                
                
                let login = self.storyboard?.instantiateViewController(withIdentifier: "TabbarViewController")
                self.navigationController?.pushViewController(login!, animated: true)
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
