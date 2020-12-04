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
    
    func getCurrentUserUid() -> String {
        
        return Auth.auth().currentUser?.uid ?? ""
        
    }
    
    func createUser(user: User) {
        
        do {
            // Add a new document in collection "users"
            let _ = try db.collection("users").document(user.uid!).setData(from: user)
            print("User created")
        }
        catch {
          print(error)
        }
        
    }
    
    func getUserData(userID: String, completion: @escaping (_ user: User?) -> Void) {
        
        let docRef = db.collection("users").document(userID)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                do {
                    let user = try document.data(as: User.self)
                    completion(user)

                } catch { print(error) }

            } else {
                print("Document does not exist")
            }
        }
    }
    
    func getUserFullname(userID: String, completion: @escaping (_ fullname: String) -> Void) {
        
        let docRef = db.collection("users").document(userID)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                let firstname = document.get("firstname")
                let lastname = document.get("lastname")
                let fullname = "\(firstname ?? "") \(lastname ?? "")"
                completion(fullname)

            } else {
                print("Document does not exist")
            }
        }
        
    }
    
    func getUserField(userID: String, field: String, completion: @escaping (_ data: Any) -> Void) {
        
        let docRef = db.collection("users").document(userID)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                let data = document.get(field)
                completion(data as Any)

            } else {
                print("Document does not exist")
            }
        }
        
    }
    
    func updateUser(user: User, completion: @escaping () -> Void) {
        
        guard let uid = user.uid else {
            return
        }
        
        let userRef = db.collection("users").document(uid)
        
        userRef.updateData([
            "firstname": user.firstname!,
            "lastname": user.lastname!,
            "campus": user.campus!,
            "degree": user.degree!,
            "birthdate": user.birthdate!,
            "image": user.image!
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
        completion()
        
    }

    
}
