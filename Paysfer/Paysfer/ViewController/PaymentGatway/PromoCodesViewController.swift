//
//  PromoCodesViewController.swift
//  Paysfer
//
//  Created by SUBHASH KUMAR on 23/09/20.
//  Copyright © 2020 VISHAL VERMA. All rights reserved.
//

import UIKit

class PromoCodesViewController: UIViewController {

    @IBOutlet weak var paymentGatwayTblView: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @objc func backAction(){
        self.navigationController?.popViewController(animated: true)
        
    }

}
