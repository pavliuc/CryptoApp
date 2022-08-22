//
//  CoinDataBaseModel.swift
//  CryptoApp
//
//  Created by Cristian Pavliuc on 20.08.2022.
//

import Foundation
import RealmSwift

enum PriceMovementType: String {
    case none
    case increased
    case decreased
}

final class CoinDataBaseModel: Object {
    
    // MARK: - Properties
    
    @Persisted(primaryKey: true) var coinCode: String
    @Persisted var coinName: String
    @Persisted var coinMinPrice: Double
    @Persisted var coinMaxPrice: Double
    @Persisted var coinImageURL: String?
    @Persisted var coinPriceHistory: List<Double>
    @Persisted var priceMovementType: String = PriceMovementType.none.rawValue
    @Persisted var coinLastPrice: Double {
        didSet {
            updateLimitPrices()
        }
    }
    
    // MARK: - Last price
    
    convenience init(code: String, name: String, lastPrice: Double,
                     minPrice: Double, maxPrice: Double, imageURL: String?) {
        self.init()
        
        coinCode = code
        coinName = name
        coinLastPrice = lastPrice
        coinMinPrice = minPrice
        coinMaxPrice = maxPrice
        coinImageURL = imageURL
    }
    
    // MARK: - Internal functions
    
    func updateCoinPrice(newValue: Double) {
        
        if newValue > coinLastPrice {
            priceMovementType = PriceMovementType.increased.rawValue
        } else if newValue < coinLastPrice {
            priceMovementType = PriceMovementType.decreased.rawValue
        } else {
            priceMovementType = PriceMovementType.none.rawValue
        }
        
        coinLastPrice = newValue
    }
    
    // MARK: - Private functions
    
    private func updateLimitPrices() {
        coinMinPrice = coinLastPrice <= coinMinPrice ? coinLastPrice : coinMinPrice
        coinMaxPrice = coinLastPrice >= coinMaxPrice ? coinLastPrice : coinMaxPrice
    }
}
