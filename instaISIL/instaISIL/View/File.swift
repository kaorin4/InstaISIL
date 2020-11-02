//
//  File.swift
//  InstaISIL
//
//  Created by Kaori on 11/1/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import Foundation
import UIKit

class Post {
    var id: String
    var author: String
    var postText: String
    var date: String
    var userImage: UIImage
    var postImage: UIImage?
    var numOfLikes: Int
    
    init(id:String, author:String, postText:String, date: String, userImage:UIImage, postImage:UIImage?, numOfLikes: Int) {
        self.id = id
        self.author = author
        self.postText = postText
        self.date = date
        self.userImage = userImage
        self.postImage = postImage
        self.numOfLikes = numOfLikes
    }
    
}
