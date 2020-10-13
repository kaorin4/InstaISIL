//
//  Common.swift
//  InstaISIL
//
//  Created by user178634 on 10/1/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class CommonUtility {
    
    /**
     appens all UITextFields included in a given view
     - Returns: Boolean. True if email has a valid format
     - Parameter email: String with email
     */
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    /**
     appens all UITextFields included in a given view
     - Parameter view: UIView that contains UITextFields
     - Parameter textFields: array of TextFields
     */
    static func getTextFields(fromView view: UIView, textFieldsArray textFields: inout [UITextField]) {
        for subview in view.subviews {
            if subview is UITextField {
                textFields.append(subview as! UITextField)
            }
        }
    }
    
    /**
     validates that text fields are not empty.
     - Returns: A string with the error message. If there is no error, returns nil
     - Parameter textFields: array of textfields to be validated
     - Parameter emailTextField: textfield for email validation. Nil if no email validation needed
     */
    static func validateTextFields(_ textFields: [UITextField], _ emailTextField: UITextField?) -> String? {
        
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
        
        if emailTextField != nil {
            // check if email has valid format
            let email: String = emailTextField!.text ?? ""
            let isEmail: Bool = isValidEmail(email)

            if !isEmail {
                return "Ingresar email válido"
            }
        }

        return nil
        
    }

    /**
     returns authentication error based on error code
     - Returns: A string with the error message. If there is no error, returns nil
     - Parameter error: auth Error
     */
    static func getAuthErrorMessage(_ error: Error?) -> String? {
        
        if error != nil {
            
            if let errCode = AuthErrorCode(rawValue: error!._code) {

                switch errCode {
                    case .invalidEmail  :
                        return "Email no válido"
                    case .userNotFound :
                        return "Usuario no registrado"
                    case .wrongPassword :
                        return "Contraseña incorrecta"
                    case .emailAlreadyInUse :
                        return "Email ya está en uso"
                    default:
                        return "Error de autenticación"
                }
            }
        }
        
        return nil
    }
    
}
