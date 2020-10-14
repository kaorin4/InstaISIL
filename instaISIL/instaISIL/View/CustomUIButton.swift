//
//  CustomUIButton.swift
//  InstaISIL
//
//  Created by user178634 on 10/10/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import UIKit

class CustomUIButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setShadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setShadow()
    }
    
    func setShadow() {
        let shadowSize: CGFloat = 20
        let contactRect = CGRect(x: 0, y: self.frame.height - (shadowSize * 0.4), width: self.frame.width - shadowSize * 2, height: shadowSize)
        self.layer.shadowPath = UIBezierPath(ovalIn: contactRect).cgPath
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.5
        let currentBackgroundColor: CGColor = self.backgroundColor!.cgColor
        self.layer.shadowColor = currentBackgroundColor
    }

}
