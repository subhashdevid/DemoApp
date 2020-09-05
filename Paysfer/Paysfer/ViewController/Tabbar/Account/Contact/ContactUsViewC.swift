//
//  ContactUsViewC.swift
//  Paysfer
//
//  Created by VISHAL VERMA on 07/07/20.
//  Copyright © 2020 VISHAL VERMA. All rights reserved.
//

import UIKit

class ContactUsViewC: UIViewController {
    
     @IBOutlet weak var contactTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @IBAction func backBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
