//
//  FollowingUserCell.swift
//  InstaISIL
//
//  Created by Kaori on 12/7/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import Foundation
import UIKit

protocol FollowingUserCellDelegate {
    
    func callSegueFromCell(sender: Any, cell: FollowingUserCell)
    
}

class FollowingUserCell: UITableViewCell {
    
    static let identifier = "FollowingUserCell"
    
    @IBOutlet weak var username: UIButton!
    
    
    
}
