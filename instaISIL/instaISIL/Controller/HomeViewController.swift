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
        
        if let controller = segue.destination as? ProfileViewController {
            
            if let cell = sender as? PostTableViewCell {
                controller.user = cell.objPost.user
            }

        }
    }
    
    deinit {
      messageListener?.remove()
    }
    
    
    func loadData() {
        
        messageListener = db.collection("posts").order(by: "timestamp", descending: true).addSnapshotListener() { querySnapshot, error in

            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    
                    do {
                        
                        let userID = diff.document.get("uid") as! String
                        let post = try diff.document.data(as: Post.self)
                        
                        post!.id = diff.document.documentID
                        
                        self.userViewModel.getUserData(userID: userID, completion: { (user) in
                            post!.user = user!
                            self.posts.append(post!)
                            
                            DispatchQueue.main.async {
                                self.table.reloadData()
                            }
                            
                        })

                    } catch { print(error) }
                }
                
                else if (diff.type == .removed) {
                    
                    let postID = diff.document.documentID
                    
                    if let index = self.posts.firstIndex(where: {$0.id == postID}) {
                        self.posts.remove(at: index)
                        
                        DispatchQueue.main.async {
                            self.table.reloadData()
                        }
                    }
                }
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

    func callSegueFromCell(sender: Any, cell: PostTableViewCell) {

        if sender as? UIButton == cell.numOfLikes {
            self.performSegue(withIdentifier: "homeToPostLikeListVC", sender: cell)
        }
        
        if sender as? UIButton == cell.commentButton {

            let indexPath = self.table.indexPath(for: cell)
            self.performSegue(withIdentifier: "homeToPostVC", sender: indexPath)
        }
        
        if sender as? UIButton == cell.usernameLabel {
            
            self.performSegue(withIdentifier: "homeToUserProfileVC", sender: cell)
            
        }
        
    }
    
    func showAlert(cell: PostTableViewCell, deletePost objPost: Post) {
        // 
    }
    
}



