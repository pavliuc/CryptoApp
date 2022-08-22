//
//  CoinDetailViewUI.swift
//  CryptoApp
//
//  Created by Cristian Pavliuc on 21.08.2022.
//

import Foundation
import UIKit
import Charts

final class CoinDetailViewControllerUI {
    
    // MARK: - UI Elements
    
    lazy var coinLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    lazy var coinCodeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 45, weight: .bold)
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var chartView: LineChartView = {
        let chartView = LineChartView()
        chartView.legend.enabled = false
        chartView.rightAxis.enabled = false
        chartView.isUserInteractionEnabled = false
        chartView.leftAxis.labelTextColor = .gray
        
        let xAxis = chartView.xAxis
        xAxis.labelTextColor = .gray
        xAxis.labelPosition = .bottom
        xAxis.labelRotationAngle = -90
        
        return chartView
    }()
    
    // MARK: - Internal functions
    
    func setupLayout(for view: UIView) {
        
        view.backgroundColor = .white
        view.addSubviews(coinLogoImageView, coinCodeLabel, chartView)
        
        coinLogoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.snp.topMargin)
            $0.size.equalTo(100)
        }
        
        coinCodeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview()
            $0.top.equalTo(coinLogoImageView.snp.bottom).offset(15)
        }
        
        chartView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(50)
            $0.height.equalTo(chartView.snp.width)
            $0.top.equalTo(coinCodeLabel.snp.bottom).offset(50)
        }
    }
}
