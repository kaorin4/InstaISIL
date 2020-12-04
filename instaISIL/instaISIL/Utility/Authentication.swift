//
//  Authentication.swift
//  InstaISIL
//
//  Created by Kaori on 12/3/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import Foundation
import Firebase

class Authentication {
    
    static func login(email: String, password: String, completion: @escaping (_ error: String?) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            
            let errMsg = CommonUtility.getAuthErrorMessage(error)
            
            if errMsg != nil {
                
                completion(errMsg)
                
            } else {
                
                completion(nil)
                
            }
                
        }
        
    }
    
}
