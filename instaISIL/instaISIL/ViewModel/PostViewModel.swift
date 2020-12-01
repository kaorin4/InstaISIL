//
//  PostViewModel.swift
//  InstaISIL
//
//  Created by Kaori on 11/30/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class PostViewModel {
    
    private var db = Firestore.firestore()
    
    private let userViewModel = UserViewModel()
    
    func getPost(with postID: String, completion: @escaping (_ post: Post?) -> Void) {
        
        let docRef = db.collection("posts").document(postID)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                do {
                    
                    let userID = document.get("uid") as! String
                    let post = try document.data(as: Post.self)
                    
                    post!.id = docRef.documentID
                    
                    self.userViewModel.getUserData(userID: userID, completion: { (user) in
                        post!.user = user!
                        completion(post)
                    })

                } catch { print(error) }

            } else {
                print("Document does not exist")
            }
        }
        
    }
    
    func getPostsByUser(with userID: String, completion: @escaping (_ posts: [Post]?) -> Void) {
        
        let docRef = db.collection("users").document(userID)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                guard let postsID = document.get("posts") else {
                    return
                }
                
                var posts = [Post]()
                
                let group = DispatchGroup()
                for postID in postsID as! [String] {
                    group.enter()
                    self.getPost(with: postID) { (post) in
                        defer { group.leave() }
                        if post != nil {
                            posts.append(post!)
                        }
                    }

                }
                group.notify(queue: .main) {
                    completion(posts)
                }

            } else {
                print("Document does not exist")
            }
        }
        
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
        
        let currentUser = userViewModel.getCurrentUserUid()
        
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
    
    func updatePostLike(objPost: Post, didLiked: Bool = false) {
        
        let postRef = db.collection("posts").document(objPost.id)
        let currentUserUid = userViewModel.getCurrentUserUid()
        
        // update database
        
        postRef.updateData([
            "likes": objPost.userLikes.count,
            "userLikes": didLiked ? FieldValue.arrayUnion([currentUserUid]) : FieldValue.arrayRemove([currentUserUid])
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
    }
    
    func addComment(objPost: Post, comment: [String: String?]) {
        
        let postRef = db.collection("posts").document(objPost.id)
        // add comment to firebase
        postRef.updateData([
            "comments": FieldValue.arrayUnion([comment])
        ])
        
    }
    
    func getComments(fromPost objPost: Post, completion: @escaping (_ comments: [Comment]?) -> Void) {
        
        let postRef = db.collection("posts").document(objPost.id)
        
        postRef.getDocument { (document, error) in
            if let document = document, document.exists {
                
                let commentsFirebase = document.get("comments")

                var commentsArr = [Comment]()
                
                if commentsFirebase != nil {
                    do {
                        let json = try JSONSerialization.data(withJSONObject: commentsFirebase as Any)
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .convertFromSnakeCase
                        commentsArr = try decoder.decode([Comment].self, from: json)
                        
                        completion(commentsArr)
                    } catch {
                        print(error)
                    }
                }
                
            } else {
                print("Document does not exist")
            }
        }
        
    }

    
}
