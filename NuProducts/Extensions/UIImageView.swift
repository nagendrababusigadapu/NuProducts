//
//  UIImageView.swift
//  NuProducts
//
//  Created by Nagendra Babu on 13/02/23.
//

import Foundation
import UIKit

extension UIImageView {
    func setImageFromUrl(url:String){
        self.sd_setImage(with: URL(string: url))
    }
}

extension UIView{
    
    func applyShadow(cornerRadius:CGFloat){
        
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        layer.shadowRadius = 4.0
        layer.shadowOpacity = 0.30
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
    }
}
