//
//  EditProfileViewController.swift
//  InstaISIL
//
//  Created by Kaori on 11/3/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var constraintBottonScrollView: NSLayoutConstraint!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var firstnameTextField: UITextField!
    
    @IBOutlet weak var lastnameTextField: UITextField!
    
    @IBOutlet weak var degreeTextField: UITextField!
    
    @IBOutlet weak var campusTextField: UITextField!
    
    @IBOutlet weak var birthdateTextField: UITextField!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var formContainer: UIView!
    
    private let userViewModel = UserViewModel()
    
    var currentUser = User()
    
    @IBAction func updateUserButtonTapped(_ sender: Any) {
        
        saveUser()
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.title = "Editar perfil"

        // Do any additional setup after loading the view.
        self.degreeTextField.delegate = self
        self.campusTextField.delegate = self
        self.birthdateTextField.delegate = self
        statusLabel.isHidden = true
        
        
        // Display user data
        
        displayProfileData()

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
    
    func displayProfileData() {
        
        let userId = userViewModel.getCurrentUserUid()
        
        userViewModel.getUserData(userID: userId) { (user) in
            
            if user != nil {
                
                self.currentUser = user!
                
                self.firstnameTextField.text = self.currentUser.firstname ?? ""
                self.lastnameTextField.text = self.currentUser.lastname ?? ""
                self.degreeTextField.text = self.currentUser.degree ?? ""
                self.campusTextField.text = self.currentUser.campus ?? ""
                self.birthdateTextField.text = self.currentUser.birthdate ?? ""
                
                if self.currentUser.image != nil {

                    self.userImage.setImage(from: self.currentUser.image!) { (image, urlString) in
                
                        if self.currentUser.image == urlString {
                            self.userImage.image = image
                        }
                        
                    }
                } else {
                    self.userImage.image = UIImage(named:"user")
                }
            }
            
        }
        
    }
    
    
    func saveUser() {
        
        currentUser.firstname = firstnameTextField.text!
        currentUser.lastname = lastnameTextField.text!
        currentUser.degree = degreeTextField.text!
        currentUser.campus = campusTextField.text!
        currentUser.birthdate = birthdateTextField.text!
        
        userViewModel.updateUser(user: currentUser) {
            
            self.displayProfileData()

            // redirect to profile
            let tabBarVC = UIStoryboard(name: "TabBar", bundle: nil).instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
                tabBarVC.selectedIndex = 3
            self.navigationController?.pushViewController(tabBarVC, animated: true)
            
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
