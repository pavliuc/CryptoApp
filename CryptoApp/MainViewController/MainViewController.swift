//
//  MainViewController.swift
//  CryptoApp
//
//  Created by Cristian Pavliuc on 19.08.2022.
//

import UIKit
import CryptoAPI
import Combine
import CombineDataSources

final class MainViewController: UIViewController {

    // MARK: - Private variables
    
    private var viewModel = MainViewControllerViewModel()
    private var viewUI: MainViewControllerUI?
    private var subscriptions = Set<AnyCancellable>()
    
    @Published private var dataBaseCoins = [CoinDataBaseModel]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewUI = MainViewControllerUI(viewController: self)
        setupBindings()        
        viewModel.getCoinsFromAPI()
    }
    
    override func viewDidLayoutSubviews() {
        
        if let viewUI = viewUI {
            viewUI.setViewControllerTitle(title: "Market")
            viewUI.setupLayout(for: view)
        }
    }
    
    // MARK: - Private functions
    
    private func setupBindings() {
        
        DataBaseManager.shared().$dataBaseCoins.sink(receiveValue: { [weak self] receivedValue in
            guard let self = self else { return }
            
            self.dataBaseCoins = receivedValue
        }).store(in: &subscriptions)
        
        if let coinsCollectionView = viewUI?.coinsCollectionView {
            $dataBaseCoins.bind(subscriber: coinsCollectionView.itemsSubscriber(cellIdentifier: CoinCollectionViewCell.cellIdentifier,
                                                                                cellType: CoinCollectionViewCell.self,
                                                                                cellConfig: { [weak self] cell, indexPath, model in
                guard let self = self else { return }
                
                cell.setCellCoin(coin: self.dataBaseCoins[indexPath.row])
            })).store(in: &subscriptions)
        }
    }
}

    // MARK: - Extensions

extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataBaseCoins.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 60)
    }
}
