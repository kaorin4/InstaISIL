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
    
    var posts :[Post] = []
    
    private var messageListener: ListenerRegistration?
        
    @IBOutlet weak var table: UITableView!
       
    private let db = Firestore.firestore()
    
    private let userViewModel = UserViewModel()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Get all posts from posts collections in firebase
        loadData()
        
        table.tableFooterView = UIView()
        
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
    
    deinit {
      messageListener?.remove()
    }
    
    
    func loadData() {
        
        messageListener = db.collection("posts").order(by: "timestamp", descending: true).addSnapshotListener() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    
                    guard let timestamp = document.get("timestamp") as? Timestamp else {
                         return
                     }
                    
                    let docRef = self.db.collection("users").document(document.get("uid") as! String)

                    docRef.getDocument(source: .server) { (userDoc, error) in
                        
                        if let userDoc = userDoc {
                            
                            do {
                                let user = try userDoc.data(as: User.self)
                                
                                let commentsFirebase = document.get("comments")

                                var commentsArr = [Comment]()
                                
                                if commentsFirebase != nil {
                                    do {
                                        let json = try JSONSerialization.data(withJSONObject: commentsFirebase as Any)
                                        let decoder = JSONDecoder()
                                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                                        commentsArr = try decoder.decode([Comment].self, from: json)
                                    } catch {
                                        print(error)
                                    }
                                }
                                
                                self.posts.append(Post(id: document.documentID,
                                                       user: user!,
                                                       postText: document.get("text") as? String ?? "",
                                                       date: timestamp.dateValue(),
                                                       postImage: document.get("image") as? String,
                                                       userLikes: Set(document.get("userLikes") as? [String] ?? [String]()),
                                                       comments: commentsArr
                                                       ))
                                
                                DispatchQueue.main.async {
                                       self.table.reloadData()
                                }
                            } catch { print(error) }

                            
                        }
                    }
                }
            }
        }
    }
    
    /*
    func checkForUpdates() {
        
        print("update")
        // listen to changes
        db.collection("posts").whereField("timestamp", isGreaterThan: Date())
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    print("Error retreiving collection: \(error)")
                }
                guard let snapshot = querySnapshot else {return}
                
                snapshot.documentChanges.forEach { (diff) in
                    
                    // append new posts
                    if diff.type == .added {

                        let username: String = "\(diff.document.get("firstname") ?? "") \(diff.document.get("lastname") ?? "")"
                        //let timestamp: Timestamp = diff.document.get("timestamp") as! Timestamp
                        guard let timestamp = diff.document.get("timestamp") as? Timestamp else {
                             return
                         }
                        
                        let commentsFirebase = diff.document.get("comments")
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

                        
                        self.posts.append(Post(id: diff.document.documentID,
                                               user: username,
                                               postText: diff.document.get("text") as? String ?? "",
                                               date: timestamp.dateValue(),
                                               userImage: diff.document.get("image") as? String ?? "",
                                               postImage: diff.document.get("image") as? String,
                                               userLikes: Set(diff.document.get("userLikes") as? [String] ?? [String]()),
                                               comments: commentsArr
                                               ))
                        
                        DispatchQueue.main.async {
                            self.table.reloadData()
                        }
                    }
                }
            }
    }*/
    
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
    
    func callSegueFromCell(sender: Any, cell: PostTableViewCell) {

        if sender as? UIButton == cell.numOfLikes {
            self.performSegue(withIdentifier: "homeToPostLikeListVC", sender: cell)
        }
        
        if sender as? UIButton == cell.commentButton {

            let indexPath = self.table.indexPath(for: cell)
            self.performSegue(withIdentifier: "homeToPostVC", sender: indexPath)
        }
        
    }
    
}



