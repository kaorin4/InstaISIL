//
//  PostTableViewCell.swift
//  InstaISIL
//
//  Created by Kaori on 11/1/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import UIKit
import Firebase

class PostTableViewCell: UITableViewCell {
    
    static let identifier = "PostTableViewCell"
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var numOfLikesLabel: UILabel!
    @IBOutlet weak var constraintPostImageHeight: NSLayoutConstraint!
        
    
    var objPost : Post! {
        didSet {
            self.updateData()
        }
    }
    
    var didLike = false
    let db = Firestore.firestore()
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        
        let postRef = db.collection("posts").document(objPost.id)
        
        didLike = !didLike
        objPost.numOfLikes += didLike ? 1 : -1
        print("likes : \(objPost.numOfLikes)")
        
        postRef.updateData([
            "likes": objPost.numOfLikes
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
        updateData()        
        
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "PostTableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userImage.layer.cornerRadius = userImage.bounds.height / 2
        userImage.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateData() {
        self.usernameLabel.text = self.objPost.user
        self.dateLabel.text = self.objPost.date.toDate(dateFormat: "dd/MM/yyyy HH:mm")
        self.postText.text = self.objPost.postText
        self.numOfLikesLabel.text = "\(self.objPost.numOfLikes) Likes"
        
        if self.objPost.userImage != nil {
            self.userImage.setImage(from: self.objPost.userImage!)
        } else {
            self.userImage.image = UIImage(named:"bunny")
        }
        
        if self.objPost.postImage != nil {
            self.postImage.setImage(from: self.objPost.postImage!)
        } else {
            constraintPostImageHeight.constant = 0
        }
        
        
    }
    
    func set(with model: Post) {
        
        self.usernameLabel.text = "\(model.user)"
        self.dateLabel.text = "\(model.date)"
        self.postText.text = "\(model.postText)"
        self.numOfLikesLabel.text = "\(model.numOfLikes) Likes"
        
        if model.userImage != nil {
            self.userImage.setImage(from: model.userImage!)
        } else {
            self.userImage.image = UIImage(named:"bunny")
        }
        
        if model.postImage != nil {
            self.postImage.setImage(from: model.postImage!)
        } else {
            constraintPostImageHeight.constant = 0
        }
        
    }
    
}


