//
//  ServerHandler.swift
//  Paysfer
//
//  Created by VISHAL VERMA on 10/06/20.
//  Copyright © 2020 VISHAL VERMA. All rights reserved.
//

import Foundation

import UIKit
import Alamofire
import SDLoader
import PKHUD

let select_country: String = "select_country.php"
let select_state: String = "select_state.php"
let select_city: String = "select_city.php"
let select_category: String = "all_services.php"
let select_type: String = "select_type.php"
let home_search: String = "home_search.php"
let add_to_wishlist: String = "add_to_wishlist.php"
let remove_wishlist: String = "remove_wishlist.php"
let wishlist_details: String = "wishlist_details.php"
let job_details: String = "job_details.php"
let change_pass: String = "change_pass.php"
let profile_edit: String = "edit_profile.php"
let contact_us: String = "contact_us.php"



let server_error = "There is a problem with our system. We apologize for the inconvenience caused. Please try again later."
let network_error = "There is no internet connection. Please try again later."


let baseURL = "http://demo12.mediatrenz.com/paysfer/Api/v1/"


class ServerHandler: NSObject{
    
   // let sdLoader = SDLoader()
    
    func getResponseFromServerByPostMethod(parametrs : [String:Any] , url: String, completion: @escaping (_ result: [String : AnyObject])->()) {
        
        if Connectivity.isConnectedToInternet() {
          //  self.sdLoader.startAnimating(atView: (UIApplication.shared.keyWindow?.rootViewController?.view)!)
            
            print("\(baseURL)\(url)")
            print(parametrs)
            Alamofire.request("\(baseURL)\(url)", method: .post, parameters: parametrs, encoding: URLEncoding.default).responseJSON { (response: DataResponse<Any>) in
               // self.sdLoader.stopAnimation()
                
                switch response.result {
                case .success(let JSON):
                    print("Response: ",JSON as! [String : AnyObject])
                    
                    completion(JSON as! [String : AnyObject])
                case .failure(let error):
                    print(error)
                    completion([:] as! [String : AnyObject])
                    AJAlertController.initialization().showAlertWithOkButton(aStrMessage: server_error) { (index, title) in
                        print(index,title)
                    }
                }
                
            }
            
//            AF.request("\(baseURL)\(url)", method: .post, parameters: parametrs, encoding: URLEncoding.default).responseJSON { (response: DataResponse<Any>) in
//
//                self.sdLoader.stopAnimation()
//
//                switch response.result {
//                case .success(let JSON):
//                    print("Response: ",JSON as! [String : AnyObject])
//                    completion(JSON as! [String : AnyObject])
//                case .failure(let error):
//                    print(error)
//
//
//                    AJAlertController.initialization().showAlertWithOkButton(aStrMessage: server_error) { (index, title) in
//                        print(index,title)
//                    }
//                }
//            }
        }else{
            AJAlertController.initialization().showAlertWithOkButton(aStrMessage: network_error) { (index, title) in
                print(index,title)
            }
        }
    }
    
    func getResponseFromServer(parametrs : String, completion: @escaping (_ result: [String:Any])->()) {
        if Connectivity.isConnectedToInternet() {
            let newParameters = parametrs.replacingOccurrences(of: " ", with: "%20")
            print("Yes! internet is available.")
           // self.sdLoader.startAnimating(atView: (UIApplication.shared.keyWindow?.rootViewController?.view)!)
            
            Alamofire.request("\(baseURL)\(newParameters)", method: .get, parameters: nil)
                
                
                .responseJSON { response in
                    
                    
                   // self.sdLoader.stopAnimation()
                    print("Request: \(baseURL)\(parametrs)")
                    switch response.result {
                    case .success(let JSON):
                        print("Response: \(JSON)")
                        completion(JSON as? [String : Any] ?? [:])
                    case .failure(let error):
                        print(error.localizedDescription)
                        AJAlertController.initialization().showAlertWithOkButton(aStrMessage: server_error) { (index, title) in
                            print(index,title)
                    }
                }
            }
        }else{
            AJAlertController.initialization().showAlertWithOkButton(aStrMessage: network_error) { (index, title) in
                print(index,title)
            }
        }
    }
    
    
    func getResponseFromCountryApi(parametrs : String, completion: @escaping (_ ress: [[String:String]])->()) {
        
        if Connectivity.isConnectedToInternet() {
            print("Yes! internet is available.")
           // self.sdLoader.startAnimating(atView: (UIApplication.shared.keyWindow?.rootViewController?.view)!)
            Alamofire.request("\(baseURL)\(parametrs)", method: .get, parameters: nil)
                           .responseJSON { response in
                    //self.sdLoader.stopAnimation()
                    switch response.result {
                    case .success(let JSON):
                        let res = JSON as! [[String:String]]
                        print("Request: \(baseURL)\(parametrs) \n Response: \(res)")
                        completion(res)
                    case .failure(let error):
                        print(error.localizedDescription)
                        AJAlertController.initialization().showAlertWithOkButton(aStrMessage: server_error) { (index, title) in
                            print(index,title)
                        }
                    }
            }
            
        }else{
            AJAlertController.initialization().showAlertWithOkButton(aStrMessage: network_error) { (index, title) in
                print(index,title)
            }
        }
    }
    
    

     func getResponseUploadImageApi(parametrs : NSDictionary,imgData:Data,imagekey:String,serviceName:String, completion: @escaping (_ ress: [String : Any])->()) {
         
         
         if Connectivity.isConnectedToInternet() {
            // self.sdLoader.startAnimating(atView: (UIApplication.shared.keyWindow?.rootViewController?.view)!)
             //
             let _url = "\(baseURL)\(serviceName)"
             print("request : ",_url, "\n params: ",parametrs)
             
             let headers: HTTPHeaders = [
                 "Content-type": "multipart/form-data"
             ]
             
             Alamofire.upload(multipartFormData: { (multipartFormData) in
                 for (key, value) in parametrs {
                     multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as! String)
                 }
                 multipartFormData.append(imgData, withName: imagekey as String, fileName: "profile_pic.png", mimeType: "image/png")
                 
             }, usingThreshold: UInt64.init(), to: _url, method: .post, headers: headers) { (result) in
                 
                 
                 switch result{
                 case .success(let upload, _, _):
                     upload.responseJSON { response in
                        // self.sdLoader.stopAnimation()
                         if response.result.value != nil
                         {
                             let dict = response.result.value! as! [String : Any]
                             print("Response: ",dict)
                             completion(dict)
                         }
                     }
                 case .failure(let error):
                     print(error.localizedDescription)
                    // self.sdLoader.stopAnimation()
                     AJAlertController.initialization().showAlertWithOkButton(aStrMessage: server_error) { (index, title) in
                         print(index,title)
                     }
                 }
             }
         }else{
             AJAlertController.initialization().showAlertWithOkButton(aStrMessage: network_error) { (index, title) in
                 print(index,title)
             }
         }
     }
    
    
    
    class Connectivity {
        class func isConnectedToInternet() ->Bool {
            return NetworkReachabilityManager()!.isReachable
        }
    }
}

