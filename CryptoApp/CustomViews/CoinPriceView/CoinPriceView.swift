//
//  CoinPriceView.swift
//  CryptoApp
//
//  Created by Cristian Pavliuc on 21.08.2022.
//

import UIKit

final class CoinPriceView: UIView {
    
    // MARK: - UI Elements
    
    private lazy var coinPriceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .regular)
        
        return label
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
      super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    }

    
    // MARK: - Private functions
    
    private func setupLayout() {
        backgroundColor = .clear
        clipsToBounds = true
        layer.cornerRadius = 5
        
        addSubviews(coinPriceLabel)
        
        coinPriceLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalToSuperview().inset(10)
        }
    }
    
    // MARK: - Internal functions
    
    func setValue(value: Double) {
        coinPriceLabel.text = "$ \(value)"
    }
}

