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
        let error = checkMandatoryFields()
        
        if error != nil {
            // there is an error
            statusLabel.isHidden = false
            statusLabel.text = error
            
        } else {
            
            //Sign in
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                
                if error != nil {
                    // sign in error
                    var errorMsg: String = ""
                    if let errCode = AuthErrorCode(rawValue: error!._code) {

                        switch errCode {
                            case .invalidEmail  :
                                errorMsg = "Email no válido"
                            case .userNotFound :
                                errorMsg = "Usuario no registrado"
                            case .wrongPassword :
                                errorMsg = "Contraseña incorrecta"
                            default:
                                errorMsg = "Error al iniciar sesión"
                        }
                    }
                    
                    self.statusLabel.isHidden = false
                    self.statusLabel.text = errorMsg

                    print(error?.localizedDescription ?? "error")
                } else {
                    // Go to homepage wohoo
                    let homeViewController = self.storyboard?.instantiateViewController(identifier: "HomeVC") as? HomeViewController
                    self.view.window?.rootViewController = homeViewController
                    self.view.window?.makeKeyAndVisible()
                }
            }
        }
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewContent.roundCorners([.topRight, .bottomRight], radius: 15)
    
        // Do any additional setup after loading the view.
        //self.view.backgroundColor = UIColor(red: 0.27, green: 0.60, blue: 0.91, alpha: 1.00)
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
