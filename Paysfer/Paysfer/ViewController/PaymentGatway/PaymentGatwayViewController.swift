//
//  PaymentGatwayViewController.swift
//  Paysfer
//
//  Created by SUBHASH KUMAR on 23/09/20.
//  Copyright © 2020 VISHAL VERMA. All rights reserved.
//

import UIKit
import Stripe

class PaymentGatwayViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    

    
    @IBOutlet weak var paymentGatwayTblView: UITableView!
    @IBOutlet weak var subTotalLbl: UILabel!
    @IBOutlet weak var discountLbl: UILabel!
    @IBOutlet weak var totalAmountLbl: UILabel!
    
    @IBOutlet weak var promobtnVw: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var applyPromoCodeBtn: UIButton!
    
    
    var subtotalprice = ""
    var disCountPrice = ""
    var totalPrice = ""
    
    var expiryDate = ""
    var cardNumber = ""
    var cvvNum = ""
    var cardName = ""
    
    
    
    let sectionTitleArr = ["","Credit / Debit Card","Paypal"]
    
    var isPromoEnabled : Bool = false
    var isPromoViewActivated : Bool = false
    var isPaymentModeSelected : Bool = false
    var selectedSection = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.paymentGatwayTblView.register(UINib.init(nibName: "PromoEnabledTableViewCell", bundle: nil), forCellReuseIdentifier: PromoEnabledTableViewCell.reuseId)

        self.paymentGatwayTblView.register(UINib.init(nibName: "PaymentSectionTableViewCell", bundle: nil), forCellReuseIdentifier: PaymentSectionTableViewCell.reuseId)
        self.paymentGatwayTblView.register(UINib.init(nibName: "CardDetailTableViewCell", bundle: nil), forCellReuseIdentifier: CardDetailTableViewCell.reuseId)
        self.paymentGatwayTblView.register(UINib.init(nibName: "PayBtnTableViewCell", bundle: nil), forCellReuseIdentifier: PayBtnTableViewCell.reuseId)
        
        self.backBtn.addTarget(self, action: #selector(backBtnAction), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.setUpCheckOutView()
    }

    
    @objc func backBtnAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func setUpCheckOutView(){
        
        
        if self.isPromoViewActivated == true{
            promobtnVw.isHidden = false
            promobtnVw.isUserInteractionEnabled = true
        }else{
            promobtnVw.isHidden = true
            promobtnVw.isUserInteractionEnabled = false
        }
        
       
        self.subTotalLbl.text = "\(subtotalprice)"
        self.discountLbl.text = "\(disCountPrice)"
        self.totalAmountLbl.text = "\(totalPrice)"
        
        applyPromoCodeBtn.addTarget(self, action: #selector(getPromoCodes), for: .touchUpInside)
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        
        if isPromoEnabled == true{
            if section == 0{
               return 1
            }else if section == 1{
                if isPaymentModeSelected == true && self.selectedSection == section{
                    return 2
                }else{
                    return 0
                }
              
            }else if section == 2{
                if isPaymentModeSelected == true && self.selectedSection == section {
                    return 1
                }else{
                    return 0
                }
            }else{
                return 0
            }
        }else{
            if section == 0{
               return 0
            }else if section == 1{
                if isPaymentModeSelected == true && self.selectedSection == section{
                    return 2
                }else{
                    return 0
                }
            }else if section == 2{
                if isPaymentModeSelected == true && self.selectedSection == section{
                    return 1
                }else{
                    return 0
                }
            }else{
                return 0
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isPromoEnabled == true{
            if section == 0{
               return 50
            }else if section == 1{
                return 50
            }else if section == 2{
                   return 50
            }else{
                return 0
            }
        }else{
            if section == 0{
               return 0
            }else if section == 1{
                return 50
            }else if section == 2{
                   return 50
            }else{
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 || section == 2{
            let headerCell = tableView.dequeueReusableCell(withIdentifier: "PaymentSectionTableViewCell") as! PaymentSectionTableViewCell
           headerCell.selectSectionBtn.tag = section
            
           headerCell.selectSectionBtn.addTarget(self, action: #selector(getSelectedRadioBtnAction(_ :)), for: .touchUpInside)
            
            if self.isPaymentModeSelected == true && selectedSection == section{
                headerCell.selectedIcon.image = UIImage.init(named: "selectedRadio")!.imageWithColor(color1: UIColor.blue)
               
            }else{
               
                headerCell.selectedIcon.image = UIImage.init(named: "unselectRadio")!.imageWithColor(color1: UIColor.blue)
               
            }
            headerCell.cellTitleLbl.text = sectionTitleArr[section]
            
            return headerCell
        }else{
            return nil
        }
         
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PromoEnabledTableViewCell", for: indexPath) as! PromoEnabledTableViewCell
            
            
            
            
        return cell
        }
        
       else if indexPath.section == 1{
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CardDetailTableViewCell", for: indexPath) as! CardDetailTableViewCell
            cell.cardNumberFLD.delegate = self
            cell.CVVFld.delegate = self
            cell.expiryDateFLD.delegate = self
           
            cell.cardNumberFLD.tag = 1
            cell.CVVFld.tag = 3
            cell.expiryDateFLD.tag = 2
            
            if  !cardNumber.isEmpty{
                cell.cardNumberFLD.text = cardNumber
            }
            if  !expiryDate.isEmpty{
                cell.expiryDateFLD.text = expiryDate
            }
            if  !cvvNum.isEmpty{
                cell.CVVFld.text = cvvNum
            }
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PayBtnTableViewCell", for: indexPath) as! PayBtnTableViewCell
            
            
            cell.payBtn.addTarget(self, action: #selector(payNowBtnClick), for: .touchUpInside)
            return cell
        }
           
       }else{
        let cell = tableView.dequeueReusableCell(withIdentifier: "PayBtnTableViewCell", for: indexPath) as! PayBtnTableViewCell
        
        cell.payBtn.addTarget(self, action: #selector(payNowBtnClick), for: .touchUpInside)
        return cell
       }
        
    }
    
    
    @objc func getPromoCodes(_ sender:UIButton) -> Void {
      
      
         //  self.navigationController?.pushViewController(vc, animated: true)
        let vc = (self.storyboard?.instantiateViewController(withIdentifier: "PromoCodesViewController") as? PromoCodesViewController)!
        
       
        self.navigationController?.pushViewController(vc, animated: true)
        
        
       }
    
    
    @objc func getSelectedRadioBtnAction(_ sender : UIButton){
        self.selectedSection = sender.tag
        self.isPromoViewActivated = true
        if self.isPaymentModeSelected == true{
        self.isPaymentModeSelected = !self.isPaymentModeSelected
        
        }else{
            self.isPaymentModeSelected = !self.isPaymentModeSelected
            
        }
        
//        guard let cell = sender.superview?.superview?.superview  as? PaymentSectionTableViewCell  else {
//            return
//        }
//
//
        self.setUpCheckOutView()
        self.paymentGatwayTblView.reloadData()
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
         if textField.tag == 1{
                   self.cardNumber = textField.text!
                   
               }
        if textField.tag == 2{
                    self.expiryDate = textField.text!
                   
        }
        if textField.tag == 3{
                   self.cvvNum = textField.text!
            }
               
                self.paymentGatwayTblView.reloadData()
    }
    
    
    @objc func payNowBtnClick(_ sender : UIButton){
        
      
        
        if cardNumber.isEmpty{
           return
        }
        if expiryDate.isEmpty{
            return
        }
        if cvvNum.isEmpty{
            return
        }
        
        let comps = expiryDate.components(separatedBy: "/")
        let f = UInt(comps.first!)
        let l = UInt(comps.last!)
        
        let cardParam = STPCardParams()
        cardParam.name = "VISA"
       
        cardParam.number = cardNumber
        cardParam.expMonth = f!
        cardParam.expYear = l!
        cardParam.cvc = cvvNum
        cardParam.currency = "usd"
        
        STPAPIClient.shared().createToken(withCard: cardParam) { (token, error) in
            
            print("token?.allResponseFields \(token?.allResponseFields)")
            print("token?.tokenId \(token?.tokenId)")
           
            
            if token != nil{
                
                Helper.showSnackBar(with: "\(token?.tokenId) \n \(token?.card?.funding)")
                
                
            }
            
        }
        
    }
}


extension UIImage {
    func imageWithColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color1.setFill()

        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(CGBlendMode.normal)

        let rect = CGRect(origin: .zero, size: CGSize(width: self.size.width, height: self.size.height))
        context?.clip(to: rect, mask: self.cgImage!)
        context?.fill(rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}
