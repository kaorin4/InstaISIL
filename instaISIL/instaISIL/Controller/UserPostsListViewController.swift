//
//  UserPostsListViewController.swift
//  InstaISIL
//
//  Created by Kaori on 11/29/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import UIKit

class UserPostsListViewController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    let userViewModel = UserViewModel()
    
    let postViewModel = PostViewModel()
    
    var userId = ""
    
    var posts = [Post]()
    
    var isDeletingAllowed = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.messageLabel.isHidden = true

        if userId == "" {
            userId = userViewModel.getCurrentUserUid()
        }

        if userId == userViewModel.getCurrentUserUid() {
            isDeletingAllowed = true
        }

        postViewModel.getPostsByUser(with: userId) { (userposts) in
            self.posts = userposts ?? [Post]()
            
            if (!(self.posts.count > 0)) {
                self.messageLabel.isHidden = false
            }
            
            DispatchQueue.main.async {
                   self.table.reloadData()
            }
            
            self.table.tableFooterView = UIView()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if let controller = segue.destination as? PostLikesViewController {
            
            if let cell = sender as? PostTableViewCell {

                controller.userlikes = Array(cell.objPost.userLikes)
                
            }
        }
        
        if let controller = segue.destination as? PostViewController {
            
            if let cell = sender as? IndexPath {
                controller.objPost = posts[cell.row]
            }

        }
    }
    
    func deletePost(_ post: Post) {
        
        self.showAlert(title: "Warning", message: "¿Deseas eliminar este post?", acceptButton: "Aceptar", cancelButton: "Cancelar", pressAccept: {
            
            guard let index = self.posts.firstIndex(where: {
                $0.id == post.id
            }) else {
                return
            }
            
            self.posts.remove(at: index)
            
            let indexPath = IndexPath(row: index, section: 0)
            self.table.deleteRows(at: [indexPath], with: .right)
            
            self.postViewModel.deletePost(postId: post.id)
            
        }, pressCancel: nil)
        
    }
    
}

extension UserPostsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.performSegue(withIdentifier: "listToPostVC", sender: indexPath)
    }
    
}

extension UserPostsListViewController: UITableViewDataSource {  // number, number, cellfor
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  table.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
        cell.delegate = self
        cell.objPost = self.posts[indexPath.row]

        print(isDeletingAllowed)
        if isDeletingAllowed {
            cell.isDeletingAllowed = true
        } else {
            cell.isDeletingAllowed = false
        }
        return cell
    }
    
}


extension UserPostsListViewController: PostTableViewCellDelegate {
    
    func showAlert(cell: PostTableViewCell, deletePost objPost: Post) {
        
        self.deletePost(objPost)
    }
    
    func callSegueFromCell(sender: Any, cell: PostTableViewCell) {
        
        if sender as? UIButton == cell.numOfLikes {
            self.performSegue(withIdentifier: "postToUserLikesVC", sender: cell)
        }
        
        if sender as? UIButton == cell.commentButton {

            let indexPath = self.table.indexPath(for: cell)
            self.performSegue(withIdentifier: "listToPostVC", sender: indexPath)
        }
    }
    
    
    
}



