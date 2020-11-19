//
//  FirebaseUtils.swift
//  InstaISIL
//
//  Created by Kaori on 11/11/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import Foundation
import Firebase

class FirebaseUtils {
    
    static func getCurrentUserUid() -> String {
        
        return Auth.auth().currentUser?.uid ?? ""
        
    }

    
}
