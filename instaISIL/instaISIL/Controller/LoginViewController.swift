//
//  LoginViewController.swift
//  InstaISIL
//
//  Created by user178634 on 10/1/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    var textFields = [UITextField]()

    @IBOutlet weak var constraintCenterYContent: NSLayoutConstraint!
    
    @IBOutlet weak var viewContent: UIView!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        checkMandatoryFields()
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
        //self.view.backgroundColor = UIColor(red: 0.27, green: 0.60, blue: 0.91, alpha: 1.00)
        statusLabel.isHidden = true

        // dismiss keyboard when no longer editing text view
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        // add textfields into array
        getTextFields(fromView: viewContent)

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
    
    private func checkMandatoryFields() {
        
        // clean status label
        statusLabel.isHidden = true
        statusLabel.text = ""
        
        var emptyFields: Int = 0

        // check empty fields
        textFields.forEach { field in
            if field.text?.count ?? 0 <= 0 {
                emptyFields+=1
            }
        }
            
        if emptyFields > 0 {
            statusLabel.isHidden = false
            statusLabel.text = "Completar todos los campos solicitados"
            return
        }
        
        // check if email has valid format        
        let email: String = emailTextField.text ?? ""
        let isEmail: Bool = CommonUtility.isValidEmail(email)

        if !isEmail {
            statusLabel.isHidden = false
            statusLabel.text = "Ingresar email válido"
        }
        
    }
    
    private func getTextFields(fromView view: UIView) {
        for subview in view.subviews {
            if subview is UITextField {
                textFields.append(subview as! UITextField)
            }
        }
    }

}
