//
//  ProfileViewC + Extension.swift
//  Paysfer
//
//  Created by VISHAL VERMA on 07/07/20.
//  Copyright © 2020 VISHAL VERMA. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import PKHUD


extension ProfileViewC : UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    func selectImageFromGallery() {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imag = UIImagePickerController()
            imag.delegate = self
            imag.sourceType = UIImagePickerController.SourceType.photoLibrary;
            imag.mediaTypes = [kUTTypeImage as String];
            imag.allowsEditing = false
            self.present(imag, animated: true, completion: nil)
        }
    }

    func selectImageFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
            let imag = UIImagePickerController()
            imag.delegate = self
            imag.sourceType = UIImagePickerController.SourceType.camera;
            imag.mediaTypes = [kUTTypeImage as String];
            imag.allowsEditing = false
            self.present(imag, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.originalImage] as? UIImage {
            self.imgUserProfile.image = image
        }
        
        self.uploadimageservice()
        self.dismiss(animated: true)
        
    }

    
    func uploadimageservice(){
        
        let userDetails = Helper.setUserDetailsInUsermodel(details: UserDefaults.standard.getUserDetails())
    
        
        let params = ["user_id":userDetails.user_id]
        
        
        //    guard let data = UIImage.jpegData(compressionQuality: 0.9) else {return}
        
        guard let imgData1 = imgUserProfile.image?.jpegData(compressionQuality: 0.2) else {return} //UIImageJPEGRepresentation(imgProfile.image!, 0.2)!
        
        service.getResponseUploadImageApi(parametrs: params as NSDictionary, imgData: imgData1, imagekey: "file", serviceName: "edit_image.php") { (results) in
            
            let status = results["status"] as? String ?? ""
            if status == "1"{
                print(results)
                UserDefaults.standard.setProfileImg(value: results["message"] as? String ?? "")
                
            }
        }
    }
}
