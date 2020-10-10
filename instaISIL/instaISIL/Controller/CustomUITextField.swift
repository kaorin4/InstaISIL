//
//  CustomUITextField.swift
//  InstaISIL
//
//  Created by user178634 on 10/3/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import UIKit

class CustomUITextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpTextField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpTextField()
    }

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    private func setUpTextField(){
        borderStyle = .none
        layer.cornerRadius = 15
        layer.borderWidth = 0
        layer.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00).cgColor
        //layer.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00).cgColor
        //layer.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00).cgColor
                
    }

}
