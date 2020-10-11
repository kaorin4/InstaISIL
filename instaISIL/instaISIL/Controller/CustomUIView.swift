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
    
    @IBInspectable var conerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = self.conerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor = .black {
        didSet {
            self.layer.borderColor = self.borderColor.cgColor
        }
    }
    
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
        //layer.cornerRadius = 15
        //layer.borderWidth = 0
        //layer.backgroundColor = UIColor.white.cgColor
        //layer.borderColor = UIColor.lightGray.cgColor
        
        // shadow
        //let rect: CGRect = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width * 0.9, height: bounds.height)
        //layer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: CGFloat(signOf: 15.0, magnitudeOf: 15.0)).cgPath
        //layer.shadowRadius = 2
        //layer.shadowOffset = .zero
        //layer.shadowOpacity = 0.25
    }

}

extension UIView {

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        
        if #available(iOS 11.0, *) {
            clipsToBounds = true
            layer.cornerRadius = radius
            layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        } else {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
        
    }
}


