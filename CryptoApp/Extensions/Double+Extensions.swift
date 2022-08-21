//
//  Double+Extensions.swift
//  CryptoApp
//
//  Created by Cristian Pavliuc on 20.08.2022.
//

import Foundation

extension Double {
    
    func rounded(toPlaces places:Int) -> Double {
        
        let divisor = pow(10.0, Double(places))
        
        return (self * divisor).rounded() / divisor
    }
}
