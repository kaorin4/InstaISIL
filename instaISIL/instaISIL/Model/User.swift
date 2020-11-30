//
//  User.swift
//  InstaISIL
//
//  Created by Kaori on 11/19/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import Foundation

class User: Codable {
    
    var uid: String
    var firstname: String
    var lastname: String
    var birthdate: String
    var campus: String
    var degree: String
    var image: String
    var posts: [String]
    
    init(uid: String, firstname: String, lastname: String, birthdate: String, campus: String, degree: String, image: String = Constants.DEFAUL_PROFILE_PIC, posts: [String] = [String]()) {
        
        self.uid = uid
        self.firstname = firstname
        self.lastname = lastname
        self.birthdate = birthdate
        self.campus = campus
        self.degree = degree
        self.image = image
        self.posts = posts
        
    }
    
}
