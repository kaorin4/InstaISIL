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
        
        // Go to login page
        guard let controller = self.navigationController?.viewControllers.first(where: {$0 is LoginViewController})
        else {
            return
            
        }
        self.navigationController?.popToViewController(controller, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
