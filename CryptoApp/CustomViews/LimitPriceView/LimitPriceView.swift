//
//  LimitPriceView.swift
//  CryptoApp
//
//  Created by Cristian Pavliuc on 19.08.2022.
//

import UIKit

enum LimitPriceViewType {
    case minimum
    case maximum
}

final class LimitPriceView: UIView {
    
    // MARK: - UIElements
    
    private lazy var limitLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 9, weight: .thin)
        
        return label
    }()
    
    private lazy var limitValueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 10, weight: .regular)
        
        return label
    }()
    
    // MARK: - Lifecycle

    override init(frame: CGRect) {
      super.init(frame: frame)
        
        setupLayout()
    }
    
    convenience init(limitType: LimitPriceViewType) {
        self.init()
        
        limitLabel.text = limitType == .minimum ? "min:" : "max:"
    }

    required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    }

    
    // MARK: - Private functions
    
    private func setupLayout() {
        backgroundColor = .clear
        addSubviews(limitLabel, limitValueLabel)
        
        limitLabel.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
        }
        
        limitValueLabel.snp.makeConstraints {
            $0.leading.equalTo(limitLabel.snp.trailing).offset(5)
            $0.top.bottom.trailing.equalToSuperview()
        }
    }
    
    // MARK: - Internal functions
    
    func setValue(value: Double) {
        limitValueLabel.text = "$ \(value)"
    }
}
