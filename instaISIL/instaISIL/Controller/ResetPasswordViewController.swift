//
//  ResetPasswordViewController.swift
//  InstaISIL
//
//  Created by user178634 on 10/3/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import UIKit
import Firebase

class ResetPasswordViewController: UIViewController {
    
    var textFields = [UITextField]()
    
    @IBOutlet weak var constraintCenterYContent: NSLayoutConstraint!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var formContainer: UIView!
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        
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
            
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            
            let errMsg = CommonUtility.getAuthErrorMessage(error)
            
            if errMsg != nil {
                
                // sign up error
                self.statusLabel.isHidden = false
                self.statusLabel.text = errMsg
                return
                
            }
            print("sent reset password email")
            self.performSegue(withIdentifier: "ResetPasswordEmailVC",sender: self)
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        formContainer.roundCorners([.topRight, .bottomRight], radius: 15)
        statusLabel.isHidden = true
        
        // dismiss keyboard when no longer editing text view
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        // add textfields into array
        CommonUtility.getTextFields(fromView: formContainer, textFieldsArray: &textFields)
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
        
        let endPosYContent = self.formContainer.frame.origin.y + self.formContainer.frame.height
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
    
    private func checkMandatoryFields() -> String? {
        
        var emptyFields: Int = 0

        // check empty fields
        textFields.forEach { field in
            if field.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0 <= 0 {
                emptyFields+=1
            }
        }
            
        if emptyFields > 0 {
            return "Completar todos los campos solicitados"
        }
        
        // check if email has valid format
        let email: String = emailTextField.text ?? ""
        let isEmail: Bool = CommonUtility.isValidEmail(email)

        if !isEmail {
            return "Ingresar email válido"
        }
        
        return nil
        
    }

}
