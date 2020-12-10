//
//  CustomUITabBarController.swift
//  InstaISIL
//
//  Created by Kaori on 12/8/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import UIKit

class CustomUITabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        
        if let homeViewController = homeStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {

            let homeIcon = UITabBarItem(title: "Home", image: UIImage(named: "home"), selectedImage: UIImage(named: "home"))
            homeViewController.tabBarItem = homeIcon
            let controllers = [homeViewController]  //array of the root view controllers displayed by the tab bar interface
            self.viewControllers = controllers

        }
    }
    
}
