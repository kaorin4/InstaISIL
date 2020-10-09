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
        layer.borderWidth = 0
        layer.backgroundColor = UIColor.white.cgColor
        //layer.borderColor = UIColor.lightGray.cgColor
        
        // shadow
        let rect: CGRect = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.width * 0.9, height: bounds.height)
        layer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: CGFloat(signOf: 15.0, magnitudeOf: 15.0)).cgPath
        layer.shadowRadius = 2
        layer.shadowOffset = .zero
        layer.shadowOpacity = 0.25
    }

}
