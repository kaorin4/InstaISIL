//
//  CustomUIView.swift
//  InstaISIL
//
//  Created by user178634 on 10/6/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import UIKit

class CustomUIView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        // rounded corner
        layer.cornerRadius = 15
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.lightGray.cgColor
        
        // shadow
        let shadowOffset: CGFloat = 10
        let contactRect = CGRect(x: bounds.origin.x + shadowOffset, y: bounds.origin.y + shadowOffset, width: bounds.width, height: bounds.height)
        layer.shadowPath = UIBezierPath(rect: contactRect).cgPath
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.4
    }

}
