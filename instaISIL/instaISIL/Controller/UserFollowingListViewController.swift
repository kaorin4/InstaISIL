//
//  UserFollowingListViewController.swift
//  InstaISIL
//
//  Created by Kaori on 12/7/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import UIKit

class UserFollowingListViewController: UIViewController {
    
    var list = [String]()
    
    @IBOutlet weak var table: UITableView!
    
    let userVM = UserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        table.tableFooterView = UIView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if let controller = segue.destination as? UserProfileViewController {
            
            if let cell = sender as? UserListCell {
                
                userVM.getUserData(userID: cell.user ?? "") { (user) in
                    controller.user = user

                }

            }

        }
    }

}

extension UserFollowingListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
}

extension UserFollowingListViewController: UITableViewDataSource {  // number, number, cellfor
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  table.dequeueReusableCell(withIdentifier: UserListCell.identifier, for: indexPath) as! UserListCell
        cell.delegate = self
        cell.user = list[indexPath.row]
           
        return cell

    }
    
}

extension UserFollowingListViewController: UserListCellDelegate {
    
    func callSegueFromCell(sender: Any, cell: UserListCell) {
        if sender as? UIButton == cell.username {
            self.performSegue(withIdentifier: "userListToUserProfileVC", sender: cell)
        }
    }
    
}
