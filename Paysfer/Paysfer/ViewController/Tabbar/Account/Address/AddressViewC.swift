//
//  AddressViewC.swift
//  Paysfer
//
//  Created by VISHAL VERMA on 07/07/20.
//  Copyright © 2020 VISHAL VERMA. All rights reserved.
//

import UIKit

class AddressViewC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    @IBOutlet weak var addressTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addressTableView.delegate = self
        self.addressTableView.dataSource = self
        self.addressTableView.backgroundColor = .white
        self.addressTableView.register(UINib.init(nibName: "sectionHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: sectionHeaderTableViewCell.reuseId)
        self.addressTableView.register(UINib.init(nibName: "AddressTableViewCell", bundle: nil), forCellReuseIdentifier: AddressTableViewCell.reuseId)
        
        // Do any additional setup after loading the view.
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
        return 2
        
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
        
        cell.backgroundColor = .white
        return cell
    }
    
   
    
    @objc func addAddressAction(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddAddressViewController") as? AddAddressViewController
              self.navigationController?.pushViewController(vc!, animated: true)
              
        
    }
    
}
