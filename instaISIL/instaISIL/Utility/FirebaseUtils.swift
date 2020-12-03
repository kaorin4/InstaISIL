//
//  FirebaseUtils.swift
//  InstaISIL
//
//  Created by Kaori on 12/1/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

class FirebaseUtils {
    
    private let storage = Storage.storage().reference()
    
    func saveFileStorage(data: Data, path: String, completion: @escaping (_ url: String) -> Void) {
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        // store image to firebase storage
        self.storage.child(path).putData(data,
                                         metadata: metaData) {
            (_, error) in

            guard error == nil else {
                print("error")
                return
            }
            
            // get url
            self.storage.child(path).downloadURL { (url, error) in
                guard let url = url, error == nil else {
                    return
                }
                
                completion(url.absoluteString)
                
            }
            
        }
        
    }
    
    
}
