//
//  CustomUITextField.swift
//  InstaISIL
//
//  Created by user178634 on 10/3/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import UIKit

class CustomUITextField: UITextField, UITextFieldDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    let border = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        setUpTextField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
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
        //borderStyle = .none
        //layer.cornerRadius = 15
        //layer.borderWidth = 0
        //layer.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00).cgColor
        //layer.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00).cgColor
        //layer.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00).cgColor
        

        let width: CGFloat = CGFloat(0.5)
        border.borderColor = UIColor(named: "app_gray")?.cgColor
        border.frame = CGRect(x: 0.0, y: self.frame.height - 1, width: self.frame.width, height: 1.0)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.borderStyle = .none
        self.layer.masksToBounds = true
                
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        border.borderColor = UIColor(named: "app_blue")?.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        border.borderColor = UIColor(named: "app_gray")?.cgColor
    }

}



