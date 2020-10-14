//
//  LoginViewController.swift
//  InstaISIL
//
//  Created by user178634 on 10/1/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    var textFields = [UITextField]()

    @IBOutlet weak var constraintCenterYContent: NSLayoutConstraint!
    
    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        // clean status label
        statusLabel.isHidden = true
        statusLabel.text = ""
               
        // validate fields
        let error = CommonUtility.validateTextFields(textFields, emailTextField)
        
        if error != nil {
            // there is an error
            statusLabel.isHidden = false
            statusLabel.text = error
            return
            
        }
            
        //Sign in
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            
            let errMsg = CommonUtility.getAuthErrorMessage(error)
            
            if errMsg != nil {
                
                // sign in error
                self.statusLabel.isHidden = false
                self.statusLabel.text = errMsg
                
            } else {
                // Go to homepage wohoo
                self.performSegue(withIdentifier: "loginToTabBarVC",sender: self)
            }
                
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        viewContent.roundCorners([.topRight, .bottomRight], radius: 15)
        statusLabel.isHidden = true

        // dismiss keyboard when no longer editing text view
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        // add textfields into array
        CommonUtility.getTextFields(fromView: viewContent, textFieldsArray: &textFields)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
        
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0
        
        let endPosYContent = self.viewContent.frame.origin.y + self.viewContent.frame.height
        let originKeyboardY = keyboardFrame.origin.y
        let spaceKeyboardToViewContent: CGFloat = 20
        var delta: CGFloat = 0
        
        if originKeyboardY < endPosYContent {
            delta = originKeyboardY - endPosYContent - spaceKeyboardToViewContent
        }
        
        UIView.animate(withDuration: animationDuration) {
            self.constraintCenterYContent.constant = delta
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0
        
        UIView.animate(withDuration: animationDuration) {
            
            self.constraintCenterYContent.constant = 0
            self.view.layoutIfNeeded()
        }
    }

}
