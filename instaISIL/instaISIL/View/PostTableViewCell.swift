//
//  PostTableViewCell.swift
//  InstaISIL
//
//  Created by Kaori on 11/1/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import UIKit


protocol PostTableViewCellDelegate {
    
    func callSegueFromCell(sender: Any, cell: PostTableViewCell)
    
    func showAlert(cell: PostTableViewCell, deletePost objPost: Post)
    
}

class PostTableViewCell: UITableViewCell {
    
    static let identifier = "PostTableViewCell"
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameLabel: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var numOfLikes: UIButton!
    @IBOutlet weak var constraintPostImageHeight: NSLayoutConstraint!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton?
    
    var delegate: PostTableViewCellDelegate?
    
    var objPost : Post! {
        didSet {
            
            if usernameLabel != nil {
                
                self.updateData()
            }
        }
    }
    
    let userViewModel = UserViewModel()
    
    let postViewModel = PostViewModel()

    var isDeletingAllowed : Bool? {
        didSet {
            if deleteButton != nil {
                if isDeletingAllowed! {
                    deleteButton?.isHidden = false
                } else {
                    deleteButton?.isHidden = true
                }
            }
        }
    }
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        
        let currentUserUid = userViewModel.getCurrentUserUid()
        
        var didLiked = false
        
        if !objPost.userLikes.contains(currentUserUid) {
            didLiked = true
            likeButton.setImage(UIImage(named: "liked"), for: .normal)
            objPost.userLikes.insert(currentUserUid)
        } else {
            likeButton.setImage(UIImage(named: "like"), for: .normal)
            objPost.userLikes.remove(currentUserUid)
        }
        
        objPost.numOfLikes = objPost.userLikes.count
        
        // update database
        postViewModel.updatePostLike(objPost: objPost, didLiked: didLiked)
        
        updateData()
        
    }
    
    
    @IBAction func listLikesButtonPressed(_ sender: Any) {

        if(self.delegate != nil){
            self.delegate?.callSegueFromCell(sender: sender, cell: self)
        }
        
    }
    
    
    @IBAction func commentButtonTapped(_ sender: Any) {
        
        if(self.delegate != nil){
            self.delegate?.callSegueFromCell(sender: sender, cell: self)
        }
        
    }
    
    
    @IBAction func usernameButtonTapped(_ sender: Any) {
        
        if(self.delegate != nil){
            self.delegate?.callSegueFromCell(sender: sender, cell: self)
        }
        
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        
        self.delegate?.showAlert(cell: self, deletePost: objPost)
        
    }
    
    static func nib() -> UINib {
        
        return UINib(nibName: "PostTableViewCell", bundle: nil)
        
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }
    
    override func draw(_ rect: CGRect) {
        
        userImage.layer.cornerRadius = userImage.bounds.height / 2
        userImage.clipsToBounds = true
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateData() {
        
        //self.usernameLabel.text = self.objPost.user.firstname
        self.usernameLabel.setTitle(self.objPost.user.firstname, for: .normal)
        self.dateLabel.text = self.objPost.date.toDate(dateFormat: "dd/MM/yyyy HH:mm")
        self.postText.text = self.objPost.postText
        self.numOfLikes.setTitle("\(self.objPost.numOfLikes) Likes", for: .normal)
        
        if self.objPost.user.image != nil {

            self.userImage.setImage(from: self.objPost.user.image!) { (image, urlString) in
        
                if self.objPost.user.image == urlString {
                    self.userImage.image = image
                }
                
            }
        } else {
            self.userImage.image = UIImage(named:"user")
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
        
        let currentUserUid = userViewModel.getCurrentUserUid()
        
        if objPost.userLikes.contains(currentUserUid) {
            likeButton.setImage(UIImage(named: "liked"), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "like"), for: .normal)
        }
        
        
    }
    
}


