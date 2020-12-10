//
//  SearchUserViewController.swift
//  InstaISIL
//
//  Created by Kaori on 11/26/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import UIKit

class SearchUserViewController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    @IBOutlet weak var searchBar: UITextField!
    
    var filteredUsers = [String]()
    
    let userVM = UserViewModel()
    
    @IBAction func searchUser(_ sender: UIButton) {
        
        guard let search = searchBar.text else {
            return
        }
        
        userVM.findUsers(withName: search) { (users) in
            
            guard let list = users else {
                return
            }
            self.filteredUsers = list
            
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        table.tableFooterView = UIView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if let controller = segue.destination as? ProfileViewController {
            
            if let cell = sender as? UserListCell {
                
                if cell.user != nil {
                    
                    controller.userID = cell.user
                }
            }

        }
    }

}


extension SearchUserViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
}

extension SearchUserViewController: UITableViewDataSource {  // number, number, cellfor
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  table.dequeueReusableCell(withIdentifier: UserListCell.identifier, for: indexPath) as! UserListCell
        cell.delegate = self
        if filteredUsers.count > 0 {
            cell.user = filteredUsers[indexPath.row]
        }

        return cell
    }
    
}

extension SearchUserViewController: UserListCellDelegate {
    
    func callSegueFromCell(sender: Any, cell: UserListCell) {
        if sender as? UIButton == cell.username {
            self.performSegue(withIdentifier: "searchToProfileVC", sender: cell)
        }
    }
    
}

