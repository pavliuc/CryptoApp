//
//  CoinCollectionViewUI.swift
//  CryptoApp
//
//  Created by Cristian Pavliuc on 19.08.2022.
//

import Foundation
import UIKit

final class CoinCollectionViewUI {
    
    // MARK: - UI Elements
    
    lazy var coinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    lazy var coinTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .regular)
        
        return label
    }()
    
    lazy var coinCodeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .thin)
        
        return label
    }()
        
    lazy var bottomLineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .gray.withAlphaComponent(0.5)
        
        return lineView
    }()
    
    lazy var coinPriceView = CoinPriceView()
    lazy var minLimitView = LimitPriceView(limitType: .minimum)
    lazy var maxLimitView = LimitPriceView(limitType: .maximum)
    
    // MARK: - Private variables
    
    /// This constant is used  for left and right padding of all elements from the cell.
    /// The main reason of the usage is to make easier the content adjustment.
    private let cellContentInset: CGFloat = 25
    
    // MARK: - Internal functions
    
    func setupLayout(in view: UIView) {
        view.backgroundColor = .white
        view.addSubviews(coinImageView, coinTitleLabel, coinCodeLabel, bottomLineView, coinPriceView, minLimitView, maxLimitView)
        
        coinImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(cellContentInset)
            $0.top.equalToSuperview()
            $0.size.equalTo(30)
        }
        
        coinTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(coinImageView)
            $0.leading.equalTo(coinImageView.snp.trailing).offset(10)
        }
        
        coinCodeLabel.snp.makeConstraints {
            $0.centerY.equalTo(coinImageView)
            $0.leading.equalTo(coinTitleLabel.snp.trailing).offset(10)
        }
        
        coinPriceView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(cellContentInset)
        }
        
        bottomLineView.snp.makeConstraints {
            $0.centerX.bottom.equalToSuperview()
            $0.width.equalToSuperview().inset(cellContentInset)
            $0.height.equalTo(1)
        }
        
        minLimitView.snp.makeConstraints {
            $0.leading.equalTo(coinTitleLabel.snp.leading)
            $0.bottom.equalTo(bottomLineView.snp.top).offset(-5)
        }
        
        maxLimitView.snp.makeConstraints {
            $0.centerY.height.equalTo(minLimitView)
            $0.leading.equalTo(minLimitView.snp.trailing).offset(15)
        }
    }
}
