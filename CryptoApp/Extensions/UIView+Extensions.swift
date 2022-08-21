//
//  UIView+Extensions.swift
//  CryptoApp
//
//  Created by Cristian Pavliuc on 19.08.2022.
//

import Foundation
import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
