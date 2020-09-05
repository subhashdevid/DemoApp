//
//  TabbarViewController.swift
//  Paysfer
//
//  Created by VISHAL VERMA on 22/06/20.
//  Copyright © 2020 VISHAL VERMA. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class TabbarViewController: UITabBarController,UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
    
          if (UserDefaults.standard.isLoggedIn() == false) {
              self.selectedIndex = 0
          }
          
        
      }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
      
         let tabBarIndex = tabBarController.selectedIndex
      
        if (UserDefaults.standard.isLoggedIn() == false) {
            
            if tabBarIndex == 1 || tabBarIndex == 2 || tabBarIndex == 3{
                
                let root = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
                
                self.navigationController?.pushViewController(root ?? UIViewController(), animated: true)
            }
        }
       
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
