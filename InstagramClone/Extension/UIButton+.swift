//
//  UIButton+.swift
//  InstagramClone
//
//  Created by yc on 2022/04/01.
//

import UIKit

extension UIButton {
    func setImage(systemName: String) {
        contentHorizontalAlignment = .fill
        contentVerticalAlignment = .fill
        imageView?.contentMode = .scaleAspectFill
        
        setImage(UIImage(systemName: systemName), for: .normal)
    }
}
