//
//  Extensions.swift
//  InstaISIL
//
//  Created by Kaori on 11/8/20.
//  Copyright © 2020 Kaori Murakami. All rights reserved.
//

import UIKit

extension UIImageView {
    
    typealias DownloadSuccess = (_ image: UIImage?, _ urlString: String) -> Void
    
    func setImage(from urlString: String, success: @escaping DownloadSuccess) {
        
        guard let imageURL = URL(string: urlString) else { return }

        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else { return }

            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                success(image, urlString)
            }
        }
    }
    
}

extension Date {
    
    func  toDate(dateFormat format  : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        let dateString = dateFormatter.string(from:self)
        return dateString
    }
    
}


