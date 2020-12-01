//
//  UserPostsListViewController.swift
//  InstaISIL
//
//  Created by Kaori on 11/29/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import UIKit

class UserPostsListViewController: UIViewController {
    
    let userViewModel = UserViewModel()
    
    let postViewModel = PostViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = userViewModel.getCurrentUserUid()
        
        postViewModel.getPostsByUser(with: user) { (posts) in
            print(posts?[0].id as Any)
            print(posts?[0].comments as Any)
        }
        
    }
    

}


