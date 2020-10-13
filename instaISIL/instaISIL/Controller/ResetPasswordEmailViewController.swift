//
//  ResetPasswordEmailViewController.swift
//  InstaISIL
//
//  Created by Kaori on 10/12/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import UIKit

class ResetPasswordEmailViewController: UIViewController {

    
    @IBAction func goBackButtonPressed(_ sender: Any) {
        
        // go to homepage
        let loginViewController = self.storyboard?.instantiateViewController(identifier: "loginVC") as? LoginViewController
        self.view.window?.rootViewController = loginViewController
        self.view.window?.makeKeyAndVisible()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
