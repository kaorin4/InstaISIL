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
    
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet var welcomeLabel: UILabel!
    
    var posts = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the views
        self.parent?.title = "Insta ISIL"
        
        table.register(PostTableViewCell.nib(), forCellReuseIdentifier: PostTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        table.reloadData()
        
        welcomeLabel.text = ""
        
        let db = Firestore.firestore()
        
        if let userId = Auth.auth().currentUser?.uid {
            let collectionRef = db.collection("users")
            let thisUserDoc = collectionRef.document(userId)
            thisUserDoc.getDocument(completion: { document, error in
                
                if let err = error {
                    print(err.localizedDescription)
                    return
                }
                if let doc = document {
                    let name = doc.get("firstname") ?? "No Name"
                    let lastname = doc.get("lastname") ?? "No lastname"
                    self.welcomeLabel.text = "Bienvenido \(name) \(lastname)"
                    print("document " + document!.documentID )
                }
            })
        }
    }

}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12//posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = 	table.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    }
    
}

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}

