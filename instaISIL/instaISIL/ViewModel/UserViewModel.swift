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
            let _ = try db.collection("users").addDocument(from: user)
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
    /*
    func getUserPosts(userID: String, completion: @escaping (_ posts: [Post]?) -> Void) {
        
        
        let docRef = db.collection("users").document(userID)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                do {

                    guard let postsID = document.get("posts") else {
                        return
                    }
                    
                    var posts = [Post]()
                    
                    for post in postsID as! [String] {
                        
                        //
                        
                        
                    }
                    
                    let user = try document.data(as: User.self)
                    //completion(user)

                } catch { print(error) }
                
                //completion(user)

            } else {
                print("Document does not exist")
            }
        }
    }*/

    
}
