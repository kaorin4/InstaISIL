//
//  PostCommentTableViewCell.swift
//  InstaISIL
//
//  Created by Kaori on 11/17/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import UIKit

class PostCommentTableViewCell: UITableViewCell {
    
    static let identifier = "PostCommentTableViewCell"
    
    private let userViewModel = UserViewModel()
    
    var postComment: Comment! {
        didSet {
            self.updateData()
        }
    }
    
    @IBOutlet var username: UILabel!
    @IBOutlet var comment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateData() {
        
        userViewModel.getUserData(userID: postComment.user) { (user) in
            
            guard let user = user else {
                return
            }
            
            self.username.text = "\(user.firstname ?? "") \(user.lastname ?? "")"
            self.comment.text = self.postComment.comment
        }

    }

}
