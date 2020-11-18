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
        username.text = postComment.user
        comment.text = postComment.comment
    }

}
