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
    
    @IBAction func postButtonPressed(_ sender: Any) {
        
        let post = [
            "text": postText.text!,
            "timestamp": FieldValue.serverTimestamp()
        ] as [String : Any]
        
        let db = Firestore.firestore()
        
        // new document with a generated id.
        var ref: DocumentReference? = nil
        ref = db.collection("posts").addDocument(data: post) {
            err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
            
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
