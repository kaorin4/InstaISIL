//
//  Post.swift
//  InstaISIL
//
//  Created by Kaori on 11/2/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import Foundation

class Post {
    var id: String
    var user: String
    var postText: String
    var date: Date
    var userImage: String?
    var postImage: String?
    var numOfLikes: Int
    var userLikes: Set<String>
    
    init(id:String, user:String, postText:String, date: Date, userImage:String?, postImage:String?, userLikes:Set<String>) {
        
        self.id = id
        self.user = user
        self.postText = postText
        self.date = date
        self.userImage = userImage
        self.postImage = postImage
        self.userLikes = userLikes
        self.numOfLikes = userLikes.count
        
    }
    
}
