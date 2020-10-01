//
//  Common.swift
//  InstaISIL
//
//  Created by user178634 on 10/1/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import Foundation


class CommonUtility{
    
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
}
