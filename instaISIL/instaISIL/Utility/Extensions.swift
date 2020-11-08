//
//  Extensions.swift
//  InstaISIL
//
//  Created by Kaori on 11/8/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }

        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
}

extension Date {
    
    func  toDate(dateFormat format  : String) -> String
   {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        let dateString = dateFormatter.string(from:self)
        return dateString
   }
    
}


