//
//  EditProfileViewController.swift
//  InstaISIL
//
//  Created by Kaori on 11/3/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import UIKit
import Firebase

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var constraintBottonScrollView: NSLayoutConstraint!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var firstnameTextField: UITextField!
    
    @IBOutlet weak var lastnameTextField: UITextField!
    
    @IBOutlet weak var degreeTextField: UITextField!
    
    @IBOutlet weak var campusTextField: UITextField!
    
    @IBOutlet weak var birthdateTextField: UITextField!
    
    @IBOutlet weak var formContainer: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Editar perfil"

        // Do any additional setup after loading the view.
        self.degreeTextField.delegate = self
        self.campusTextField.delegate = self
        self.birthdateTextField.delegate = self
        statusLabel.isHidden = true
        
        
        // Get user session data
        
        let db = Firestore.firestore()
        
        if let userId = Auth.auth().currentUser?.uid {
            let collectionRef = db.collection("users")
            let thisUserDoc = collectionRef.document(userId)
            thisUserDoc.getDocument(completion: { document, error in
                
                if let err = error {
                    print(err.localizedDescription)
                    return
                }
                if let doc = document {
                    self.firstnameTextField.text = doc.get("firstname") as? String ?? "No Name"
                    self.lastnameTextField.text = doc.get("lastname") as? String ?? "No lastname"
                    self.campusTextField.text = doc.get("campus") as? String ?? "No campus"
                    self.degreeTextField.text = doc.get("degree") as? String ?? "No degree"
                    self.birthdateTextField.text = doc.get("birthdate") as? String ?? "No date"
                }
            })
        }
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

}

extension EditProfileViewController: PickerOptionViewControllerDelegate {
    
    func pickerOptionViewController(_ controller: PickerOptionViewController, didSelectOption option: Any) {
        if let sender = controller.sender as? CustomUITextField {
            sender.text = "\(option)"
        }
    }
}

extension EditProfileViewController: DatePickerSelectViewControllerDelegate {
    
    
    func datePickerSelectViewController(_ controller: DatePickerSelectViewController, didSelectDate date: Date) {
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "dd/MM/yyyy"
        dateFormat.locale = Locale(identifier: "es_PE")
        
        let textDate = dateFormat.string(from: date)
        
        self.birthdateTextField.text = textDate
        
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == self.degreeTextField {
            self.performSegue(withIdentifier: "editProfileToOptionPickerVC", sender: self.degreeTextField)
            return false
        }
        else if textField == self.campusTextField {
            self.performSegue(withIdentifier: "editProfileToOptionPickerVC", sender: self.campusTextField)
            return false
        }
        else if textField == self.birthdateTextField {
            self.performSegue(withIdentifier: "editProfileToDatePickerVC", sender: self.birthdateTextField)
            return false
        }
        
        return true
        
    }
}
