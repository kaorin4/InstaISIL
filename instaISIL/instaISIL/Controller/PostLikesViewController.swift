//
//  PostLikesViewController.swift
//  InstaISIL
//
//  Created by Kaori on 11/12/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import UIKit

class PostLikesViewController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    
    var userlikes = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.tableFooterView = UIView()
    }

}

extension PostLikesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // llamar segue al post (cuando cree uno :D )
    }
    
}

extension PostLikesViewController: UITableViewDataSource {  // number, number, cellfor
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userlikes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  table.dequeueReusableCell(withIdentifier: PostLikesViewCell.identifier, for: indexPath) as! PostLikesViewCell
        cell.username.text = userlikes[indexPath.row]
        return cell
    }
    
}
