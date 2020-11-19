//
//  PostViewController.swift
//  InstaISIL
//
//  Created by Kaori on 11/17/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import UIKit
import Firebase

class PostViewController: UIViewController {
    
    @IBOutlet var postUsername: UILabel!
    @IBOutlet var postText: UILabel!
    @IBOutlet var postDate: UILabel!
    @IBOutlet var postUsernameImage: UIImageView!
    @IBOutlet var postImage: UIImageView!
    @IBOutlet var postLikes: UIButton!
    @IBOutlet var constraintPostImageHeight: NSLayoutConstraint!
    @IBOutlet weak var postCommentTextfield: UITextField!
    
    @IBOutlet var table: UITableView!
    
    
    var objPost = Post(id: "", user: "", postText: "", date: Date(), userImage: nil, postImage: nil, userLikes: Set<String>())
    
    let db = Firestore.firestore()
    
    @IBAction func postCommentButtonPressed(_ sender: Any) {
        
        let comment = postCommentTextfield.text
        
        let currentUserUid = FirebaseUtils.getCurrentUserUid()
        
        let firebaseComment = ["comment": comment, "user": currentUserUid]
        
        let postRef = db.collection("posts").document(objPost.id)
        
        // add comment to firebase
        postRef.updateData([
            "comments": FieldValue.arrayUnion([firebaseComment])
        ])

        // refresh data
        postRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
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
                
                self.objPost.comments = commentsArr
                self.table.reloadData()
                
                self.postCommentTextfield.text = ""
                
            } else {
                print("Document does not exist")
            }
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateData()
        
        table.tableFooterView = UIView()

    }
    
    func updateData() {
        self.postUsername.text = self.objPost.user
        self.postDate.text = self.objPost.date.toDate(dateFormat: "dd/MM/yyyy HH:mm")
        self.postText.text = self.objPost.postText
        self.postLikes.setTitle("\(self.objPost.numOfLikes) Likes", for: .normal)
        
        if self.objPost.userImage != nil {
            self.postUsernameImage.setImage(from: self.objPost.userImage!) { (image, urlString) in
                if self.objPost.userImage == urlString {
                    self.postUsernameImage.image = image
                }
            }
        } else {
            self.postUsernameImage.image = UIImage(named:"user")
        }
        
        if self.objPost.postImage != nil {
            self.postImage.setImage(from: self.objPost.postImage!) { (image, urlString) in
                if self.objPost.postImage == urlString {
                    self.postImage.image = image
                }
            }
        } else {
            constraintPostImageHeight.constant = 0
        }
        
    }

}

extension PostViewController: UITableViewDataSource {  // number, number, cellfor
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objPost.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  table.dequeueReusableCell(withIdentifier: PostCommentTableViewCell.identifier, for: indexPath) as! PostCommentTableViewCell
        cell.postComment = self.objPost.comments[indexPath.row]

        return cell
    }
    
}
