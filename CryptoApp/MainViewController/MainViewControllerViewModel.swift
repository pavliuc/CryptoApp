//
//  MainViewControllerViewModel.swift
//  CryptoApp
//
//  Created by Cristian Pavliuc on 19.08.2022.
//

import Foundation
import CryptoAPI
import Combine

final class MainViewControllerViewModel {
    
    // MARK: - Private variables
    
    private var cryptoAPI: Crypto!
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Internal variables
    
    @Published var coins: [Coin] = []
    @Published var selectedCoin: CoinDataBaseModel!
    @Published var dataBaseCoinModels: [CoinDataBaseModel] = []
    
    // MARK: - Lifecycle
    
    init() {
        cryptoAPI = Crypto(delegate: self)
        setupBindings()
    }
    
    // MARK: - Private functions
    
    private func setupBindings() {
        
        $coins.sink(receiveValue: { receivedValue in
            
            DataBaseManager.shared().receivedCoinsFromAPI = receivedValue
        }).store(in: &subscriptions)
        
        DataBaseManager.shared().$dataBaseCoins.sink(receiveValue: { [weak self] receivedValue in
            guard let self = self else { return }
            
            self.dataBaseCoinModels = receivedValue
            DataBaseManager.shared().startCoinsPriceMonitoring()
        }).store(in: &subscriptions)
    }
    
    // MARK: - Internal functions
    
    func getCoinsFromAPI() {
        _ = cryptoAPI.connect()
        cryptoAPI.connect().publisher.sink(receiveCompletion: { result in
            switch result {
            case .failure(let error):
                fatalError(error.localizedDescription)
            case .finished:
                break
            }
        }, receiveValue: { [weak self] isConnected in
            guard let self = self else { return }
            
            if isConnected {
                
                /// Is connected to the API and now we request the coins from there
                self.coins = self.cryptoAPI.getAllCoins()
            } else {
                
                /// Retry to connect to the API and get the coins
                self.getCoinsFromAPI()
            }
        }).store(in: &subscriptions)
    }
    
    func userSelectedCoin(coin: CoinDataBaseModel) {
        selectedCoin = coin
    }
    
    func getCoinCodeForIndex(index: Int) -> CoinDataBaseModel? {
        return dataBaseCoinModels[index]
    }
}

    // MARK: - Extensions

extension MainViewControllerViewModel: CryptoDelegate {
    
    func cryptoAPIDidUpdateCoin(_ coin: Coin) {
        DataBaseManager.shared().updateCoinValue(coin: coin, isAppLaunchUpdate: false)
    }
    
    func cryptoAPIDidConnect() {}
    
    func cryptoAPIDidDisconnect() {}
}
