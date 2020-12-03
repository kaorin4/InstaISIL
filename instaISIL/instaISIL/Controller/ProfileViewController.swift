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
    
    
    @IBAction func showUserPostsButtonTapped(_ sender: Any) {
        
        self.performSegue(withIdentifier: "profileToUserPostsVC",sender: self)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        displayProfileData()
        
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
