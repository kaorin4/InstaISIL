//
//  CreatePostViewController.swift
//  InstaISIL
//
//  Created by Kaori on 11/5/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import UIKit
import Firebase

class CreatePostViewController: UIViewController {
    
    @IBOutlet weak var postText: UITextView!
    
    @IBOutlet weak var prevImg: UIImageView!
    
    let pickerController = UIImagePickerController()

    @IBAction func pickPhotoButtonPressed(_ sender: Any) {
        
        pickerController.sourceType = .photoLibrary
        pickerController.allowsEditing = true
        present(pickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func postButtonPressed(_ sender: Any) {
        
        let db = Firestore.firestore()
        
        if let userId = Auth.auth().currentUser?.uid {

            let collectionRef = db.collection("users")
            let thisUserDoc = collectionRef.document(userId)
            thisUserDoc.getDocument(completion: { document, error in
                
                if let err = error {
                    print(err.localizedDescription)
                    return
                }
                if document != nil {
                    
                    let post = [
                        "uid": document!.documentID,
                        "text": self.postText.text!,
                        "likes": 0,
                        "timestamp": FieldValue.serverTimestamp()
                    ] as [String : Any]
                    
                    // new document with a generated id.
                    var ref: DocumentReference? = nil
                    ref = db.collection("posts").addDocument(data: post) {
                        err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {
                            print("Document added with ID: \(ref!.documentID)")
                            
                            // redirect to home tab
                            let tabBarVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
                                tabBarVC.selectedIndex = 0
                            self.navigationController?.pushViewController(tabBarVC, animated: true)
                        }
                    }
                }
                
            })
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
        
        print("\(info)")
        //let image = info.
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
