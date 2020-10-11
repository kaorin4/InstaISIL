//
//  ResetPasswordViewController.swift
//  InstaISIL
//
//  Created by user178634 on 10/3/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        
        // clean status label
        statusLabel.text = ""
        statusLabel.isHidden = true
        
        // check if empty
        if emailTextField.text?.count ?? 0 <= 0 {
            statusLabel.isHidden = false
            statusLabel.text = "Completar todos los campos solicitados"
            return
        }
        
        // check if email is valid
        let email: String = emailTextField.text ?? ""
        let isEmail: Bool = CommonUtility.isValidEmail(email)
        if !isEmail {
            statusLabel.isHidden = false
            statusLabel.text = "Ingresar email válido"
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        statusLabel.isHidden = true
        
        // dismiss keyboard when no longer editing text view
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
