//
//  PostTableViewCell.swift
//  InstaISIL
//
//  Created by Kaori on 11/1/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import UIKit
import Firebase


protocol PostTableViewCellDelegate {
    
    func callSegueFromCell(_ controller: PostTableViewCell)
    
}

class PostTableViewCell: UITableViewCell {
    
    static let identifier = "PostTableViewCell"
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var numOfLikes: UIButton!
    @IBOutlet weak var constraintPostImageHeight: NSLayoutConstraint!
    @IBOutlet weak var likeButton: UIButton!
    
    var delegate: PostTableViewCellDelegate?
    
    var objPost : Post! {
        didSet {
            self.updateData()
        }
    }
    
    let db = Firestore.firestore()
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        
        let postRef = db.collection("posts").document(objPost.id)
        
        let currentUserUid = FirebaseUtils.getCurrentUserUid()
        
        var didLiked = false
        
        if !objPost.userLikes.contains(currentUserUid) {
            didLiked = true
            objPost.userLikes.insert(currentUserUid)
        } else {
            objPost.userLikes.remove(currentUserUid)
        }
        
        objPost.numOfLikes = objPost.userLikes.count
        
        // update database
        
        postRef.updateData([
            "likes": objPost.userLikes.count,
            "userLikes": didLiked ? FieldValue.arrayUnion([currentUserUid]) : FieldValue.arrayRemove([currentUserUid])
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
        updateData()
        
    }
    
    
    @IBAction func listLikesButtonPressed(_ sender: Any) {

        if(self.delegate != nil){
            self.delegate?.callSegueFromCell(self)
        }
        
    }
    
    
    static func nib() -> UINib {
        
        return UINib(nibName: "PostTableViewCell", bundle: nil)
        
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }
/*
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userImage.layer.cornerRadius = userImage.bounds.height / 2
        userImage.clipsToBounds = true
        
    }*/
    
    override func draw(_ rect: CGRect) {
        
        userImage.layer.cornerRadius = userImage.bounds.height / 2
        userImage.clipsToBounds = true
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateData() {
        self.usernameLabel.text = self.objPost.user
        self.dateLabel.text = self.objPost.date.toDate(dateFormat: "dd/MM/yyyy HH:mm")
        self.postText.text = self.objPost.postText
        self.numOfLikes.setTitle("\(self.objPost.numOfLikes) Likes", for: .normal)
        
        if self.objPost.userImage != nil {
            self.userImage.setImage(from: self.objPost.userImage!) { (image, urlString) in
        
                if self.objPost.userImage == urlString {
                    self.userImage.image = image
                }
                
            }
        } else {
            self.userImage.image = UIImage(named:"user")
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


