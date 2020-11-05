//
//  PostTableViewCell.swift
//  InstaISIL
//
//  Created by Kaori on 11/1/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import UIKit

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
        self.dateLabel.text = self.objPost.date
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

extension UIImageView {
    
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }

        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
}
