//
//  UIImageView+Extensions.swift
//  CryptoApp
//
//  Created by Cristian Pavliuc on 19.08.2022.
//

import Foundation
import UIKit

extension UIImageView {
    func setImageFrom(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
