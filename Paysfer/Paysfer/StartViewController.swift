//
//  StartViewController.swift
//  Paysfer
//
//  Created by VISHAL VERMA on 06/07/20.
//  Copyright © 2020 VISHAL VERMA. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: {(timer: Timer) -> Void in
                    //let login = self.storyboard?.instantiateViewController(withIdentifier: "signin")
                    let login = self.storyboard?.instantiateViewController(withIdentifier: "TabbarViewController")
                    self.navigationController?.pushViewController(login!, animated: true)
   
        //            }
                })

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
