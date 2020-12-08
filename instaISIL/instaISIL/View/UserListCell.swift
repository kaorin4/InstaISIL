//
//  UserListCell.swift
//  InstaISIL
//
//  Created by Kaori on 12/7/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import UIKit

protocol UserListCellDelegate {
    
    func callSegueFromCell(sender: Any, cell: UserListCell)
    
}

class UserListCell: UITableViewCell {
    
    static let identifier = "UserListCell"
    
    @IBOutlet weak var username: UIButton!
    
    var user: String? {
        didSet {
            userVM.getUserFullname(userID: user!) { (fullname) in
                self.username.setTitle(fullname, for: .normal)
            }
        }
    }
    
    var delegate: UserListCellDelegate?
    
    let userVM = UserViewModel()
    
    
    @IBAction func seeUserButtonTapped(_ sender: Any) {
        
        if(self.delegate != nil){
            self.delegate?.callSegueFromCell(sender: sender, cell: self)
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    
}
