//
//  Post2.swift
//  InstaISIL
//
//  Created by Kaori on 11/29/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import Foundation

class Post2: Codable {
    
    var id: String = ""
    var user: User = User()
    var postText: String
    var date: Date
    var postImage: String?
    var numOfLikes: Int
    var userLikes: Set<String>
    var comments: [Comment]
    
    enum CodingKeys: String, CodingKey {
        case postText = "text"
        case date = "timestamp"
        case numOfLikes = "likes"
        case comments
        case postImage = "image"
        case userLikes
    }
    
    required init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)

        postText = try values.decodeIfPresent(String.self, forKey: .postText) ?? ""
        date = try values.decodeIfPresent(Date.self, forKey: .date)!
        numOfLikes = try values.decodeIfPresent(Int.self, forKey: .numOfLikes) ?? 0
        userLikes = try values.decodeIfPresent(Set<String>.self, forKey: .userLikes) ?? Set<String>()
        comments = try values.decodeIfPresent([Comment].self, forKey: .comments) ?? [Comment]()
    }
    
    init(id: String, user: User, postText: String, date: Date, postImage: String?, userLikes: Set<String>, comments: [Comment] = [Comment]()) {
        
        self.id = id
        self.user = user
        self.postText = postText
        self.date = date
        self.postImage = postImage
        self.userLikes = userLikes
        self.numOfLikes = userLikes.count
        self.comments = comments
        
    }
    
    
}
