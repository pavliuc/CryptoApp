//
//  CoinCollectionViewCell.swift
//  CryptoApp
//
//  Created by Cristian Pavliuc on 19.08.2022.
//

import UIKit
import CryptoAPI
import Combine

final class CoinCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Cell identifier
    
    static let cellIdentifier = "CoinCollectionViewCell"
    
    // MARK: - Private variables
    
    private let cellUI = CoinCollectionViewUI()
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Internal variables
    
    @Published var cellCoin: CoinDataBaseModel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        cellUI.setupLayout(in: self)
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private functions
    
    private func setupBindings() {
        
        DataBaseManager.shared().$updatedCoin.sink(receiveValue: { [weak self] receivedValue in
            guard let self = self else { return }
            
            if let receivedValue = receivedValue {
                if self.cellCoin.coinName == receivedValue.coinName {
                    self.cellCoin = receivedValue
                }
            }
        }).store(in: &subscriptions)
        
        $cellCoin.sink(receiveValue: { [weak self] receivedCoin in
            guard let self = self else { return }
            
            if let receivedCoin = receivedCoin {
                
                if let coinImageURLString = receivedCoin.coinImageURL, let imageURL = URL(string: coinImageURLString) {
                    self.cellUI.coinImageView.setImageFrom(url: imageURL)
                }

                self.cellUI.coinTitleLabel.text = receivedCoin.coinName
                self.cellUI.coinCodeLabel.text = receivedCoin.coinCode
                
                let placesAfterComma = 3
                self.cellUI.coinPriceView.setValue(value: receivedCoin.coinLastPrice.rounded(toPlaces: placesAfterComma))
                self.cellUI.minLimitView.setValue(value: receivedCoin.coinMinPrice.rounded(toPlaces: placesAfterComma))
                self.cellUI.maxLimitView.setValue(value: receivedCoin.coinMaxPrice.rounded(toPlaces: placesAfterComma))
                
                self.updatePriceViewBackgroundColor(movementType: PriceMovementType(rawValue: receivedCoin.priceMovementType) ?? .none)
            }
        }).store(in: &subscriptions)
    }
    
    // MARK: - Internal functions
    
    func setCellCoin(coin: CoinDataBaseModel) {
        cellCoin = coin
    }
    
    // MARK: - Private functions
    
    private func updatePriceViewBackgroundColor(movementType: PriceMovementType) {
        
        switch movementType {
            case .increased:
                self.cellUI.coinPriceView.backgroundColor = .green
            
            case .decreased:
                self.cellUI.coinPriceView.backgroundColor = .red
            
            case .none:
                self.cellUI.coinPriceView.backgroundColor = .clear
        }
    }
}
