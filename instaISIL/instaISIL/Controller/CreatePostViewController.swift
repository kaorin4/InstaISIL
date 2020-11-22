//
//  CreatePostViewController.swift
//  InstaISIL
//
//  Created by Kaori on 11/5/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage


class CreatePostViewController: UIViewController {
    
    @IBOutlet weak var postText: UITextView!
    
    @IBOutlet weak var prevImg: UIImageView!
    
    let pickerController = UIImagePickerController()
    
    private let storage = Storage.storage().reference()
    
    var imageData: Data?
    
    let fireUtil = FirebaseUtils()

    @IBAction func pickPhotoButtonPressed(_ sender: Any) {
        
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func postButtonPressed(_ sender: Any) {
        
        let userId = FirebaseUtils.getCurrentUserUid()
        
        if userId != "" {
            
            let uuid = UUID().uuidString
            let path = "images/\(userId)/posts/\(uuid)"

            var urlString = ""
            
            if self.imageData != nil {
                
                let metaData = StorageMetadata()
                metaData.contentType = "image/jpg"

                
                // store image to firebase storage
                self.storage.child(path).putData(self.imageData!,
                                                 metadata: metaData) {
                    (_, error) in
                    
                    guard error == nil else {
                        print("error")
                        return
                    }
                    
                    // get url
                    self.storage.child(path).downloadURL { (url, error) in
                        guard let url = url, error == nil else {
                            return
                        }
                        
                        urlString = url.absoluteString

                        // save post to cloud firestore
                        self.fireUtil.savePost(withText: self.postText.text!, fromUser: userId, imageUrl: urlString) { () in
                            
                            // redirect to home tab
                            let tabBarVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
                                tabBarVC.selectedIndex = 0
                            self.navigationController?.pushViewController(tabBarVC, animated: true)
                            
                        }
                        
                    }
                    
                }
            } else {
                
                self.fireUtil.savePost(withText: self.postText.text!, fromUser: userId, imageUrl: nil) { () in
                    
                    // redirect to home tab
                    let tabBarVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
                        tabBarVC.selectedIndex = 0
                    self.navigationController?.pushViewController(tabBarVC, animated: true)
                    
                }

            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        pickerController.delegate = self
    }

}

extension CreatePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        guard let d: Data = image.jpegData(compressionQuality: 0.5) else { return }
        
        imageData = d
        
        prevImg.image = image
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
