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
        
        // Get all posts from posts collections in firebase
        
        let db = Firestore.firestore()
        
        db.collection("posts").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    
                    let timestamp: Timestamp = document.get("timestamp") as! Timestamp
                    
                    let docRef = db.collection("users").document(document.get("uid") as! String)

                    docRef.getDocument(source: .cache) { (userDoc, error) in
                        
                        if let userDoc = userDoc {
                            
                            let username: String = "\(userDoc.get("firstname") ?? "") \(userDoc.get("lastname") ?? "")"
                            
                            let commentsFirebase = document.get("comments")
                            var commentsArr = [Comment]()
                            
                            if commentsFirebase != nil {
                                do {
                                    let json = try JSONSerialization.data(withJSONObject: commentsFirebase)
                                    let decoder = JSONDecoder()
                                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                                    commentsArr = try decoder.decode([Comment].self, from: json)
                                } catch {
                                    print(error)
                                }
                            }
                        
                            self.posts.append(Post(id: document.documentID,
                                                   user: username,
                                                   postText: document.get("text") as? String ?? "",
                                                   date: timestamp.dateValue(),
                                                   userImage: userDoc.get("image") as? String ?? "",
                                                   postImage: document.get("image") as? String,
                                                   userLikes: Set(document.get("userLikes") as? [String] ?? [String]()),
                                                   comments: commentsArr
                                                   ))
                            
                            DispatchQueue.main.async {
                                self.table.reloadData()
                            }
                            
                        }
                    }
                }
            }
        }
        

        /*
        
        posts.append(Post(id: "1", user: "user1", postText: "this is a post", date: date, userImage: "https://cdn4.iconfinder.com/data/icons/small-n-flat/24/user-alt-512.png", postImage: nil, numOfLikes: 10))
        
        posts.append(Post(id: "2", user: "user2", postText: "this is a post 2", date: date, userImage: nil , postImage: "https://static.wikia.nocookie.net/pokemon/images/4/49/Ash_Pikachu.png/revision/latest?cb=20200405125039", numOfLikes: 20))
        */
        
        // add custom table cell to table view
        
        //table.register(PostTableViewCell.nib(), forCellReuseIdentifier: PostTableViewCell.identifier)
        //table.delegate = self
        //table.dataSource = self
        //table.tableFooterView = UIView()
        //table.reloadData()
        
        welcomeLabel.text = ""
        
        // Get user session data
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if let controller = segue.destination as? PostLikesViewController {
            
            if let cell = sender as? PostTableViewCell {
                controller.userlikes = Array(cell.objPost.userLikes)
            }
        }
        
        if let controller = segue.destination as? PostViewController {
            
            if let cell = sender as? IndexPath {
                controller.objPost = posts[cell.row]
            }
        }
    }
    
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.performSegue(withIdentifier: "homeToPostVC", sender: indexPath)
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
        cell.delegate = self
        cell.objPost = self.posts[indexPath.row]

        return cell
    }
    
}

extension HomeViewController: PostTableViewCellDelegate {
    
    func callSegueFromCell(_ controller: PostTableViewCell) {
        self.performSegue(withIdentifier: "homeToPostLikeListVC", sender: controller )
    }
    
}



