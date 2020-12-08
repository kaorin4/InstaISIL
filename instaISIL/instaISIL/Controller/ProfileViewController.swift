//
//  ProfileViewController.swift
//  InstaISIL
//
//  Created by Kaori on 11/3/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lastnameLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var campusLabel: UILabel!
    @IBOutlet weak var birthdateLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    let userViewModel = UserViewModel()
    
    var user : User? {
        didSet {
            self.updateData()
        }
    }
    
    @IBAction func showUserPostsButtonTapped(_ sender: Any) {
        
        self.performSegue(withIdentifier: "profileToUserPostsVC",sender: self)
        
    }
    
    @IBAction func showFollowingUsersButtonTapped(_ sender: Any) {
        
        self.performSegue(withIdentifier: "profileToFollowingList",sender: self)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //displayProfileData()

        if user == nil {
            let userId = userViewModel.getCurrentUserUid()
            userViewModel.getUserData(userID: userId) { (userData) in
                self.user = userData
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if let controller = segue.destination as? UserPostsListViewController {
            
            controller.isDeletingAllowed = true
        }
        
        if let controller = segue.destination as? UserFollowingListViewController {
            
            guard let followingList = user?.following else {
                return
            }
            
            controller.list = followingList

        }
    }
       
    func updateData() {
        
        guard let userProfile = user else {
            return
        }

        nameLabel.text = "Nombre: \(userProfile.firstname ?? "")"
        lastnameLabel.text = "Apellido: \(userProfile.lastname ?? "")"
        degreeLabel.text = "Carrera: \(userProfile.degree ?? "")"
        campusLabel.text = "Campus: \(userProfile.campus ?? "")"
        birthdateLabel.text = "Nacimiento: \(userProfile.birthdate ?? "")"
        
        if userProfile.image != nil {

            self.userImage.setImage(from: userProfile.image!) { (image, urlString) in
        
                if userProfile.image == urlString {
                    self.userImage.image = image
                }
                
            }
        } else {
            self.userImage.image = UIImage(named:"user")
        }
        
    }
    
    func displayProfileData() {
        
        let userId = userViewModel.getCurrentUserUid()
        
        userViewModel.getUserData(userID: userId) { (user) in
            
            self.nameLabel.text = "Nombre: \(user?.firstname ?? "")"
            self.lastnameLabel.text = "Apellido: \(user?.lastname ?? "")"
            self.degreeLabel.text = "Carrera: \(user?.degree ?? "")"
            self.campusLabel.text = "Campus: \(user?.campus ?? "")"
            self.birthdateLabel.text = "Nacimiento: \(user?.birthdate ?? "")"
            
            if user?.image != nil {

                self.userImage.setImage(from: user!.image!) { (image, urlString) in
            
                    if user?.image == urlString {
                        self.userImage.image = image
                    }
                    
                }
            } else {
                self.userImage.image = UIImage(named:"user")
            }
            
        }
        
    }
    
}
