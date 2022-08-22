//
//  CoinDetailsViewController.swift
//  CryptoApp
//
//  Created by Cristian Pavliuc on 21.08.2022.
//

import UIKit
import Combine
import Charts

final class CoinDetailsViewController: UIViewController {

    // MARK: - Private variables
    
    private let viewUI = CoinDetailViewControllerUI()
    private var subscriptions = Set<AnyCancellable>()
    private var viewModel: CoinDetailViewModel!
    
    // MARK: - Life cycle
    
    convenience init(coin: CoinDataBaseModel, viewModel: CoinDetailViewModel) {
        self.init()
        
        self.viewModel = viewModel
        viewModel.selectedCoin = coin
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
    }
    
    override func viewDidLayoutSubviews() {
        viewUI.setupLayout(for: view)
    }
    
    // MARK: - Private functions
    
    private func setupBindings() {
        
        viewModel.$selectedCoin.sink(receiveValue: { [weak self] receivedValue in
            guard let self = self else { return }
            
            if let receivedCoin = receivedValue {
             
                self.viewUI.coinCodeLabel.text = receivedCoin.coinCode
                self.viewModel.getChartDataForCoin()
                if let coinImageURLString = receivedCoin.coinImageURL, let imageURL = URL(string: coinImageURLString) {
                    self.viewUI.coinLogoImageView.setImageFrom(url: imageURL)
                }
            } 
        }).store(in: &subscriptions)
        
        
        viewModel.$charViewData.sink(receiveValue: { [weak self] dataSet in
            guard let self = self else { return }
            
            self.viewUI.chartView.data = dataSet
        }).store(in: &subscriptions)
    }
}
