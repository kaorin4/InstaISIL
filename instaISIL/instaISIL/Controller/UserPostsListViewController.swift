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
    
    let firebaseUtils = FirebaseUtils()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = userViewModel.getCurrentUserUid()
        
        firebaseUtils.getPostsByUser(with: user) { (posts) in
            print(posts?.count)
        }
        
    }
    

}


