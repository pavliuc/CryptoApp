//
//  DataBaseManager.swift
//  CryptoApp
//
//  Created by Cristian Pavliuc on 20.08.2022.
//

import Foundation
import RealmSwift
import CryptoAPI
import Combine

final class DataBaseManager {
    
    private static let sharedDataBaseManager = DataBaseManager()
    
    // MARK: - Internal variables
    
    var realm: Realm {
        return try! Realm()
    }
    
    var isEmpty: Bool {
        return realm.objects(CoinDataBaseModel.self).isEmpty
    }
    
    var dataBaseCoinObjects: Results<CoinDataBaseModel> {
        return realm.objects(CoinDataBaseModel.self)
    }
    
    var receivedCoinsFromAPI: [Coin] = [] {
        didSet {
            if isEmpty {
                addCoinsToDataBase(coins: receivedCoinsFromAPI)
            } else {
                updateCoinsValues(coins: receivedCoinsFromAPI)
            }
        }
    }
    
    // MARK: - Private variables
    
    @Published private(set) var updatedCoin: CoinDataBaseModel? = nil
    @Published private(set) var dataBaseCoins: [CoinDataBaseModel] = []

    
    // MARK: - Accessors

    class func shared() -> DataBaseManager {
        return sharedDataBaseManager
    }
    
    // MARK: - Internal functions
    
    func addCoinsToDataBase(coins: [Coin]) {
        let realmInstance = realm
        
        try! realmInstance.write {
            coins.forEach { coin in
                let coinDataBaseModel = CoinDataBaseModel(code: coin.code,
                                                          name: coin.name,
                                                          lastPrice: coin.price,
                                                          minPrice: coin.price,
                                                          maxPrice: coin.price,
                                                          imageURL: coin.imageUrl)
                
                realmInstance.add(coinDataBaseModel)
            }
        }
    }
    
    func updateCoinsValues(coins: [Coin]) {
        coins.forEach {
            updateCoinValue(coin: $0)
        }
        dataBaseCoins = dataBaseCoinObjects.toArray(ofType: CoinDataBaseModel.self)
    }
    
    func updateCoinValue(coin: Coin, isAppLaunchUpdate: Bool = true) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if let dataBaseCoin = self.dataBaseCoinObjects.first(where: { $0.coinCode == coin.code }) {
                                
                try! self.realm.write {
                    dataBaseCoin.updateCoinPrice(newValue: coin.price)
                }
                
                if !isAppLaunchUpdate {
                    self.updatedCoin = dataBaseCoin
                }
            }
        }
    }
}
