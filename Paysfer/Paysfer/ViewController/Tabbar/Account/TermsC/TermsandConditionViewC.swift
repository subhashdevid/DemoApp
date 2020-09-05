//
//  TermsandConditionViewC.swift
//  Paysfer
//
//  Created by VISHAL VERMA on 07/07/20.
//  Copyright © 2020 VISHAL VERMA. All rights reserved.
//

import UIKit
import WebKit


class TermsandConditionViewC: UIViewController, WKNavigationDelegate {
     @IBOutlet weak var termsTableView: UITableView!
    @IBOutlet weak var wbVw: WKWebView!
    @IBOutlet weak var ActivityIn: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ActivityIn.startAnimating()
        wbVw.navigationDelegate = self
        let url = URL(string:"http://demo12.mediatrenz.com/paysfer/Api/privacy/terms-condition.html")
        wbVw.load(URLRequest(url: url!))
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        ActivityIn.stopAnimating()
        ActivityIn.isHidden = true
    }
    @IBAction func backBtnAction(_ sender: Any) {
        ActivityIn.stopAnimating()
              ActivityIn.isHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    
}
