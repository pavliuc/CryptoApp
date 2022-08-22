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
    
    var isEmpty: Bool {
        if let realm = realm {
            return realm.objects(CoinDataBaseModel.self).isEmpty
        }
        
        return true
    }
    
    var dataBaseCoinObjects: Results<CoinDataBaseModel>? {
        return realm?.objects(CoinDataBaseModel.self)
    }
    
    var receivedCoinsFromAPI: [Coin] = [] {
        didSet {
            if isEmpty {
                addCoinsToDataBase(coins: receivedCoinsFromAPI)
            } else {
                updateCoinsValues(coins: receivedCoinsFromAPI)
            }
            
            if let dataBaseCoinObjects = dataBaseCoinObjects {
                dataBaseCoins = dataBaseCoinObjects.toArray(ofType: CoinDataBaseModel.self)
            }
        }
    }
    
    // MARK: - Private variables
    
    @Published private(set) var updatedCoin: CoinDataBaseModel? = nil
    @Published private(set) var dataBaseCoins: [CoinDataBaseModel] = []
    private var realm: Realm?
    private var timer = Timer()
    
    // MARK: - Accessors

    class func shared() -> DataBaseManager {
        return sharedDataBaseManager
    }
    
    // MARK: - Lifecycle
    
    init() {
        realm = try? Realm()
    }
    
    // MARK: - Internal functions
    
    func addCoinsToDataBase(coins: [Coin]) {
        
        let realmInstance = realm
        let coinsDataBaseModels = createCoinDataBaseModels(from: coins)
        
        try? realmInstance?.write {
            realmInstance?.add(coinsDataBaseModels)
        }
        
    }
    
    func updateCoinsValues(coins: [Coin]) {
        
        coins.forEach {
            updateCoinValue(coin: $0)
        }
    }
    
    func updateCoinValue(coin: Coin, isAppLaunchUpdate: Bool = true) {
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if let dataBaseCoin = self.dataBaseCoinObjects?.first(where: { $0.coinCode == coin.code }) {
                                
                try? self.realm?.write {
                    dataBaseCoin.updateCoinPrice(newValue: coin.price)
                }
                
                if !isAppLaunchUpdate {
                    self.updatedCoin = dataBaseCoin
                }
            }
        }
    }
    
    
    func startCoinsPriceMonitoring() {
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            guard let self = self else { return }
            
            self.updateCoinsPriceHistory()
        })
    }
    
    func getCoin(code: String) -> CoinDataBaseModel? {
        return dataBaseCoinObjects?.first(where: { $0.coinCode == code })
    }
    
    // MARK: Private functions
    
    private func createCoinDataBaseModels(from coins: [Coin]) -> [CoinDataBaseModel] {
        var coinDataBaseModels = [CoinDataBaseModel]()
        
        coins.forEach { coin in
            let coinDataBaseModel = CoinDataBaseModel(code: coin.code,
                                                      name: coin.name,
                                                      lastPrice: coin.price,
                                                      minPrice: coin.price,
                                                      maxPrice: coin.price,
                                                      imageURL: coin.imageUrl)
            
            coinDataBaseModels.append(coinDataBaseModel)
        }
        
        return coinDataBaseModels
    }
    
    private func updateCoinsPriceHistory() {
        dataBaseCoinObjects?.forEach { coinObject in
            try? realm?.write {
                coinObject.coinPriceHistory.append(coinObject.coinLastPrice)
            }
        }
    }
}
