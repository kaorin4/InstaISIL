//
//  PostViewController.swift
//  InstaISIL
//
//  Created by Kaori on 11/17/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    
    @IBOutlet var postUsername: UILabel!
    @IBOutlet var postText: UILabel!
    @IBOutlet var postDate: UILabel!
    @IBOutlet var postUsernameImage: UIImageView!
    @IBOutlet var postImage: UIImageView!
    @IBOutlet var postLikes: UIButton!
    @IBOutlet var constraintPostImageHeight: NSLayoutConstraint!
    @IBOutlet weak var postCommentTextfield: UITextField!
    
    
    @IBOutlet weak var commentContainer: UIStackView!
    @IBOutlet weak var commentBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet var table: UITableView!
    
    
    var objPost = Post(id: "", user: User(), postText: "", date: Date(), postImage: nil, userLikes: Set<String>())
    
    let userViewModel = UserViewModel()
    
    let postViewModel = PostViewModel()
    
    @IBAction func postCommentButtonPressed(_ sender: Any) {
        
        let comment = postCommentTextfield.text
        
        let currentUserUid = userViewModel.getCurrentUserUid()
        
        let firebaseComment = ["comment": comment, "user": currentUserUid]
        
        // add comment to firebase
        postViewModel.addComment(objPost: objPost, comment: firebaseComment)

        // refresh data
        postViewModel.getComments(fromPost: objPost) { (comments) in
            
            if comments != nil {
                self.objPost.comments = comments!
                self.table.reloadData()
                
                self.postCommentTextfield.text = ""
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateData()
        
        // dismiss keyboard when no longer editing text view
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        table.tableFooterView = UIView()

    }
    
    func updateData() {
        self.postUsername.text = self.objPost.user.firstname
        self.postDate.text = self.objPost.date.toDate(dateFormat: "dd/MM/yyyy HH:mm")
        self.postText.text = self.objPost.postText
        self.postLikes.setTitle("\(self.objPost.numOfLikes) Likes", for: .normal)
        
        if self.objPost.user.image != nil {
            self.postUsernameImage.setImage(from: self.objPost.user.image!) { (image, urlString) in
                if self.objPost.user.image == urlString {
                    self.postUsernameImage.image = image
                }
            }
        } else {
            self.postUsernameImage.image = UIImage(named:"user")
        }
        
        if self.objPost.postImage != "" {
            self.postImage.setImage(from: self.objPost.postImage!) { (image, urlString) in
                if self.objPost.postImage == urlString {
                    self.postImage.image = image
                }
            }
        } else {
            constraintPostImageHeight.constant = 0
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
        
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0
        
        UIView.animate(withDuration: animationDuration) {

            self.commentBottomConstraint.constant = keyboardFrame.size.height + 5
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0
        
        UIView.animate(withDuration: animationDuration) {
            
            self.commentBottomConstraint.constant = 20
            self.view.layoutIfNeeded()
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
