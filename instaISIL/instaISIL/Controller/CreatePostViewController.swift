//
//  CreatePostViewController.swift
//  InstaISIL
//
//  Created by Kaori on 11/5/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import UIKit


class CreatePostViewController: UIViewController {
    
    @IBOutlet weak var postText: UITextView!
    
    @IBOutlet weak var prevImg: UIImageView!
    
    let pickerController = UIImagePickerController()
    
    var imageData: Data?
    
    let userViewModel = UserViewModel()
    
    let postViewModel = PostViewModel()
    
    let firebaseUtil = FirebaseUtils()

    @IBAction func pickPhotoButtonPressed(_ sender: Any) {
        
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func postButtonPressed(_ sender: Any) {
        createPost()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        pickerController.delegate = self
    }
    
    func createPost() {

        let userId = userViewModel.getCurrentUserUid()
        
        if userId != "" {
            
            let uuid = UUID().uuidString
            let path = "images/\(userId)/posts/\(uuid)"
            
            guard let img = self.imageData else {
                
                self.postViewModel.savePost(withText: self.postText.text!, fromUser: userId, imageUrl: nil) { () in
                    
                    // redirect to home tab
                    let tabBarVC = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
                        tabBarVC.selectedIndex = 0
                    self.navigationController?.pushViewController(tabBarVC, animated: true)
                    
                }
                return
            }

            firebaseUtil.saveFileStorage(data: img, path: path) { (url) in
                
                // save post to cloud firestore
                self.postViewModel.savePost(withText: self.postText.text!, fromUser: userId, imageUrl: url) { () in
                    
                    // redirect to home tab
                    let tabBarVC = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
                        tabBarVC.selectedIndex = 0
                    self.navigationController?.pushViewController(tabBarVC, animated: true)
                    
                }
                
            }

        }
        
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
