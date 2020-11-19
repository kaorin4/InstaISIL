//
//  UserViewModel.swift
//  InstaISIL
//
//  Created by Kaori on 11/19/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class UserViewModel {
    
    private var db = Firestore.firestore()
    
    func createUser(user: User) {
        
        do {
            // Add a new document in collection "users"
            let _ = try db.collection("users").addDocument(from: user)
            print("User created")
        }
        catch {
          print(error)
        }
        
    }
    
}
