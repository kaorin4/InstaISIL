//
//  HomeViewController.swift
//  InstaISIL
//
//  Created by Kaori on 10/11/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    @IBOutlet var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let userID : String = (Auth.auth().currentUser?.uid)!

            //Auth.auth()?.currentUser?.uid)!
        print("Current user ID is" + userID)
        
        let db = Firestore.firestore()
        
        if let userId = Auth.auth().currentUser?.uid {
            let collectionRef = db.collection("users")
            let thisUserDoc = collectionRef.document(userId)
            thisUserDoc.getDocument(completion: { document, error in
                if let err = error {
                    print(err.localizedDescription)
                    return
                }
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                }
                if let doc = document {
                    let name = doc.get("firstname") ?? "No Name"
                    let lastname = doc.get("lastname") ?? "No lastname"
                    self.welcomeLabel.text = "Bienvenido \(name) \(lastname)"
                    print("document " + document!.documentID )
                    print("Hey, \(name) welcome!")
                }
            })
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
