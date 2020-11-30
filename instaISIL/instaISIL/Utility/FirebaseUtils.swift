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
    
    private let db = Firestore.firestore()
    
    func getCurrentUserUid() -> String {
        
        return Auth.auth().currentUser?.uid ?? ""
        
    }
    

    
    func savePost(withText text: String, fromUser uid: String, imageUrl url: String?, completion: @escaping () -> Void) {
        
        let post = [
            "uid": uid,
            "text": text,
            "likes": 0,
            "timestamp": FieldValue.serverTimestamp(),
            "image": url ?? ""
        ] as [String : Any]
        
        // new document with a generated id
        var ref: DocumentReference? = nil
        
        ref = db.collection("posts").addDocument(data: post) {
            err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                
                let documentId: String = ref!.documentID
                
                self.addToUserPostList(postId: documentId)
                
                completion()

            }
        }
    }
    
    func addToUserPostList(postId: String) {
        
        let currentUser = getCurrentUserUid()
        
        let userRef = db.collection("users").document(currentUser)
        
        // update database
        userRef.updateData([
            "posts": FieldValue.arrayUnion([postId])
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
    }

    
}
