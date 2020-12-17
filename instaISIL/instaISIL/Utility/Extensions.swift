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

extension UIViewController {
    
    typealias PressAlertAction = ()->Void
    
    func showAlert(title: String, message: String, acceptButton: String, pressAccept: PressAlertAction? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
      
        let acceptAction = UIAlertAction(title: acceptButton, style: .default) { (_) in
            pressAccept?()
        }
        
        alertController.addAction(acceptAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func showAlert(title: String, message: String, acceptButton: String, cancelButton: String, pressAccept: PressAlertAction? = nil, pressCancel: PressAlertAction? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let acceptAction = UIAlertAction(title: acceptButton, style: .default) { (_) in
            pressAccept?()
        }
        
        let cancelAction = UIAlertAction(title: cancelButton, style: .cancel) { (_) in
            pressCancel?()
        }
          
        alertController.addAction(acceptAction)
        alertController.addAction(cancelAction)
          
        self.present(alertController, animated: true, completion: nil)
    }

}

extension UITextField {
    func disableAutoFill() {
        if #available(iOS 12, *) {
            textContentType = .oneTimeCode
        } else {
            textContentType = .init(rawValue: "")
        }
    }
}



