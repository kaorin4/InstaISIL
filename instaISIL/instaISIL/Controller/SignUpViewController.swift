//
//  SignUpViewController.swift
//  InstaISIL
//
//  Created by user178634 on 10/3/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {
    
    var textFields = [UITextField]()
    
    @IBOutlet weak var constraintBottonScrollView: NSLayoutConstraint!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var firstnameTextField: UITextField!
    
    @IBOutlet weak var lastnameTextField: UITextField!
    
    @IBOutlet weak var degreeTextField: UITextField!
    
    @IBOutlet weak var campusTextField: UITextField!
    
    @IBOutlet weak var birthdateTextField: UITextField!
    
    @IBOutlet weak var formContainer: UIView!
    
    @IBAction func SignUpButtonPressed(_ sender: Any) {
        
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
        createUser()
        
    }
    
    @IBAction func toLoginPageButtonPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "signupToLoginVC",sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formContainer.roundCorners([.topRight, .bottomRight], radius: 15)
        self.degreeTextField.delegate = self
        self.campusTextField.delegate = self
        self.birthdateTextField.delegate = self;
        
        statusLabel.isHidden = true
        
        // dismiss keyboard when no longer editing text view
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        // add textfields into array
        CommonUtility.getTextFields(fromView: formContainer, textFieldsArray: &textFields)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if let controller = segue.destination as? PickerOptionViewController {
            controller.delegate = self
            
            if let textField = sender as? CustomUITextField {
                controller.sender = sender
                
                if textField == self.degreeTextField {
                    controller.arrayData = Constants.DEGREES
                }
                else if textField == self.campusTextField {
                    controller.arrayData = Constants.CAMPUS_LOCATIONS
                }
            }
        } else if let controller = segue.destination as? DatePickerSelectViewController {
            controller.delegate = self
            
        } 
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
        
        UIView.animate(withDuration: animationDuration) {
            self.constraintBottonScrollView.constant = keyboardFrame.size.height
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0
        
        UIView.animate(withDuration: animationDuration) {
            
            self.constraintBottonScrollView.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    private func createUser() {
        
        // data to be stored
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let firstname = firstnameTextField.text!.trimmingCharacters(in: .newlines)
        let lastname = lastnameTextField.text!.trimmingCharacters(in: .newlines)
        let degree = degreeTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let campus = campusTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let birthdate = birthdateTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // create user
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            
            let errMsg = CommonUtility.getAuthErrorMessage(error)
            
            if errMsg != nil {
                
                // sign up error
                self.statusLabel.isHidden = false
                self.statusLabel.text = errMsg
                
            } else {
                // user was created
                let db = Firestore.firestore()
            
                // Add a new document in collection "users"
                db.collection("users").document((authResult?.user.uid)!).setData([
                    "uid": authResult!.user.uid,
                    "firstname": firstname,
                    "lastname": lastname,
                    "degree": degree,
                    "campus": campus,
                    "birthdate": birthdate
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                }

                // Go to homepage wohoo
                self.performSegue(withIdentifier: "signupToTabBarVC",sender: self)

            }
                       
        }
    }

}

extension SignUpViewController: PickerOptionViewControllerDelegate {
    
    func pickerOptionViewController(_ controller: PickerOptionViewController, didSelectOption option: Any) {
        if let sender = controller.sender as? CustomUITextField {
            sender.text = "\(option)"
        }
        print("picker delegate")
    }
    
}

extension SignUpViewController: DatePickerSelectViewControllerDelegate {
    
    
    func datePickerSelectViewController(_ controller: DatePickerSelectViewController, didSelectDate date: Date) {
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy"
        dateFormat.locale = Locale(identifier: "es_PE")
        
        let textDate = dateFormat.string(from: date)
        
        self.birthdateTextField.text = textDate
        
        print("date picker delegate")
    }
}

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // switch
        if textField == self.degreeTextField {
            self.performSegue(withIdentifier: "DegreePickerViewController", sender: self.degreeTextField)
            return false
        }
        else if textField == self.campusTextField {
            self.performSegue(withIdentifier: "DegreePickerViewController", sender: self.campusTextField)
            return false
        }
        else if textField == self.birthdateTextField {
            self.performSegue(withIdentifier: "DatePickerViewController", sender: self.birthdateTextField)
            return false
        }
        
        return true
        
    }
}




