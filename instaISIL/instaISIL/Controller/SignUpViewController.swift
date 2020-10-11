//
//  SignUpViewController.swift
//  InstaISIL
//
//  Created by user178634 on 10/3/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    var textFields = [UITextField]()
    
    @IBOutlet weak var constraintBottonScrollView: NSLayoutConstraint!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var degreeTextField: UITextField!
    
    @IBOutlet weak var campusTextField: UITextField!
    
    @IBOutlet weak var birthdateTextField: UITextField!
    
    @IBOutlet weak var formContainer: UIView!
    
    @IBAction func SignUpButtonPressed(_ sender: Any) {
        
        checkMandatoryFields()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.degreeTextField.delegate = self
        self.campusTextField.delegate = self
        self.birthdateTextField.delegate = self;
        
        // Do any additional setup after loading the view.
        statusLabel.isHidden = true
        
        
        // dismiss keyboard when no longer editing text view
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        // add textfields into array
        getTextFields(fromView: formContainer)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        super.prepare(for: segue, sender: sender)
        
        if let controller = segue.destination as? PickerOptionViewController {
            controller.delegate = self
            
            if let textField = sender as? CustomUITextField {
                controller.sender = sender
                
                if textField == self.degreeTextField {
                    controller.arrayData = ["Software", "Sistemas", "Admin"]
                }
                else if textField == self.campusTextField {
                    controller.arrayData = ["San Isidro", "La Molina", "Miraflores"]
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




