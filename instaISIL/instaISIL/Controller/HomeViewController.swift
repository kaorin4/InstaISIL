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
    
    var posts:[Post] = []
        
    @IBOutlet weak var table: UITableView!
    @IBOutlet var welcomeLabel: UILabel!
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the views
        self.parent?.title = "InstaISIL"
        
        posts.append(Post(id: "1", user: "user1", postText: "this is a post", date: "11/2/2020", userImage: "https://cdn4.iconfinder.com/data/icons/small-n-flat/24/user-alt-512.png", postImage: nil, numOfLikes: 10))
        
        posts.append(Post(id: "2", user: "user2", postText: "this is a post 2", date: "11/2/2020", userImage: nil , postImage: "https://static.wikia.nocookie.net/pokemon/images/4/49/Ash_Pikachu.png/revision/latest?cb=20200405125039", numOfLikes: 20))
        
        posts.append(Post(id: "3", user: "user2", postText: "this is a post 2", date: "11/2/2020", userImage: nil , postImage: "https://static.wikia.nocookie.net/pokemon/images/4/49/Ash_Pikachu.png/revision/latest?cb=20200405125039", numOfLikes: 50))
        
        // add custom table cell to table view
        
        table.register(PostTableViewCell.nib(), forCellReuseIdentifier: PostTableViewCell.identifier)
        //table.delegate = self
        //table.dataSource = self
        table.tableFooterView = UIView()
        table.reloadData()
        
        welcomeLabel.text = ""
        
        // Get user session data
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // llamar segue al post (cuando cree uno :D )
    }
    
}

extension HomeViewController: UITableViewDataSource {  // number, number, cellfor
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  table.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
        //cell.set(with: posts[indexPath.row])
        cell.objPost = self.posts[indexPath.row]
        return cell
    }
    
}

