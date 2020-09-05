//
//  AppDelegate.swift
//  Paysfer
//
//  Created by VISHAL VERMA on 04/06/20.
//  Copyright © 2020 VISHAL VERMA. All rights reserved.
//

import UIKit
import SideMenu
import IQKeyboardManagerSwift
import Firebase
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit


@available(iOS 13.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,GIDSignInDelegate {
    
    
    

var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true

        UITabBar.appearance().tintColor = UIColor.white
               UITabBar.appearance().barTintColor = #colorLiteral(red: 0.4236943424, green: 0.2528171539, blue: 0.7804867029, alpha: 1)
        
        
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
       
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions:
            launchOptions
        )
        
        menuCustom()
        // Override point for customization after application launch.
        return true
    }

    
    func applicationDidBecomeActive(_ application: UIApplication) {
        AppEvents.activateApp()
    }
    
    // MARK:- UISceneSession Lifecycle

    
    
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
    
    func menuCustom(){
        
    
        // Define the menus
        let leftMenuNavigationController = SideMenuNavigationController(rootViewController: SlideMenuController())
        SideMenuManager.default.leftMenuNavigationController = leftMenuNavigationController
    }

    
    
    //MARK:- GOOGLE SIGN IN
    
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
        
        let appId: String = Settings.appID ?? ""
        if url.scheme != nil && url.scheme!.hasPrefix("fb\(appId)") && url.host ==  "authorize" {
        return ApplicationDelegate.shared.application(application, open: url, options: options)
        }else{
            return GIDSignIn.sharedInstance().handle(url)
        }
        
      
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        // ...
        if error != nil {
            
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
       
        let userModel = Auth.auth().currentUser
        if userModel?.uid == nil {
            //Show Login Screen
        } else {
            //Show content
            
            print("Login Successful.")
            
        }
       
    
    }
    
    

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    
//    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
//      if let error = error {
//        print(error.localizedDescription)
//        return
//      }
//      // ...
//    }
    
    
//    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
//
//    }
    
   
    
    
}

