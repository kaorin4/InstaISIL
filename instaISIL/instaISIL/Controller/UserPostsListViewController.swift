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
    
}

extension UserPostsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        //self.performSegue(withIdentifier: "homeToPostVC", sender: indexPath)
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

        if isDeletingAllowed {
            cell.isDeletingAllowed = true
        }

        return cell
    }
    
}


extension UserPostsListViewController: PostTableViewCellDelegate {
    
    func callSegueFromCell(sender: Any, cell: PostTableViewCell) {
        /*
        if sender as? UIButton == cell.numOfLikes {
            self.performSegue(withIdentifier: "homeToPostLikeListVC", sender: cell)
        }
        
        if sender as? UIButton == cell.commentButton {

            let indexPath = self.table.indexPath(for: cell)
            self.performSegue(withIdentifier: "homeToPostVC", sender: indexPath)
        }*/
        
    }
    
}



