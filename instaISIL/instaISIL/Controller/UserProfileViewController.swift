//
//  UserProfileViewController.swift
//  InstaISIL
//
//  Created by Kaori on 12/3/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import Foundation
import UIKit

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastnameLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var campusLabel: UILabel!
    @IBOutlet weak var birthdateLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var followButtonHeightConstraint: NSLayoutConstraint!
    
    let userViewModel = UserViewModel()
    
    var isFollowed = false
    
    var user : User? {
        didSet {
            loadViewIfNeeded()
            self.updateData()
        }
    }
    
    @IBAction func followUser(_ sender: UIButton) {
        
        isFollowed = !isFollowed
        if isFollowed {
            sender.setTitle("Seguido", for: .normal)
            userViewModel.followUser(followingUserId: user?.uid ?? "")
        } else {
            sender.setTitle("Seguir", for: .normal)
            userViewModel.unfollowUser(followingUserId: user?.uid ?? "")
        }
    }
    
    @IBAction func showUserPostsButtonTapped(_ sender: Any) {
        
        self.performSegue(withIdentifier: "userProfileToUserPostsVC",sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userViewModel.isFollowedByCurrentUser(followingUserId: user?.uid ?? "") {followed in
            if followed {
                self.isFollowed = true
                self.followButton.setTitle("Seguido", for: .normal)
            } else {
                self.isFollowed = false
                self.followButton.setTitle("Seguir", for: .normal)
            }
        }
        let currentUser = userViewModel.getCurrentUserUid()
        if user?.uid == currentUser {
            followButton.isHidden = true
            followButtonHeightConstraint.constant = 0
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if let controller = segue.destination as? UserPostsListViewController {
            
            controller.userId = user?.uid ?? ""
        }
    }
    
    func updateData() {
        
        guard let userProfile = user else {
            return
        }

        nameLabel?.text = "Nombre: \(userProfile.firstname ?? "")"
        lastnameLabel?.text = "Apellido: \(userProfile.lastname ?? "")"
        degreeLabel?.text = "Carrera: \(userProfile.degree ?? "")"
        campusLabel?.text = "Campus: \(userProfile.campus ?? "")"
        birthdateLabel?.text = "Nacimiento: \(userProfile.birthdate ?? "")"
        
        if userProfile.image != nil {

            userImage?.setImage(from: userProfile.image!) { (image, urlString) in
        
                if userProfile.image == urlString {
                    self.userImage?.image = image
                }
                
            }
        } else {
            userImage?.image = UIImage(named:"user")
        }
        
    }
    
}
