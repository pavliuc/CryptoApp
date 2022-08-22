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
    
    private var viewModel: MainViewControllerViewModel!
    private var viewUI: MainViewControllerUI!
    private var subscriptions = Set<AnyCancellable>()
        
    // MARK: - Lifecycle
    
    convenience init(viewModel: MainViewControllerViewModel) {
        self.init()
        
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewUI = MainViewControllerUI(viewController: self)
        viewUI.setViewControllerTitle(title: "Market")
        viewModel.getCoinsFromAPI()
        setupBindings()        
    }
    
    override func viewDidLayoutSubviews() {
        viewUI.setupLayout(for: view)
    }
    
    // MARK: - Private functions
    
    private func setupBindings() {
        
        viewModel.$dataBaseCoinModels.bind(subscriber: viewUI.coinsCollectionView.itemsSubscriber(cellIdentifier: CoinCollectionViewCell.cellIdentifier,
                                                                                cellType: CoinCollectionViewCell.self,
                                                                                cellConfig: { [weak self] cell, indexPath, model in
                guard let self = self else { return }
                
                cell.setCellCoin(coin: self.viewModel.dataBaseCoinModels[indexPath.row])
            })).store(in: &subscriptions)
        
        viewModel.$selectedCoin.sink(receiveValue: { [weak self] selectedCoin in
            guard let self = self else { return }
            
            if let selectedCoin = selectedCoin {
                self.pushCoinDetailsViewController(coin: selectedCoin)
            }
        }).store(in: &subscriptions)
    }
    
    private func pushCoinDetailsViewController(coin: CoinDataBaseModel) {
        let coinDetailViewController = CoinDetailsViewController(coin: coin, viewModel: CoinDetailViewModel())
        self.navigationController!.pushViewController(coinDetailViewController, animated: true)
    }
}

    // MARK: - Extensions

extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dataBaseCoinModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedCoin = viewModel.getCoinCodeForIndex(index: indexPath.row) {
            if let coin = DataBaseManager.shared().getCoin(code: selectedCoin.coinCode) {
                viewModel.userSelectedCoin(coin: coin)
            }
        }
    }
}
