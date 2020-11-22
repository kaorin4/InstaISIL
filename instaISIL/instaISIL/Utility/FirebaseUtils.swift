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
    
    static func getCurrentUserUid() -> String {
        
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
                
                completion()

            }
        }
    }

    
}
