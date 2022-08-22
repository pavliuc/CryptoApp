//
//  CoinDetailViewModel.swift
//  CryptoApp
//
//  Created by Cristian Pavliuc on 22.08.2022.
//

import Foundation
import Combine
import Charts
import UIKit

final class CoinDetailViewModel {
    
    // MARK: - Internal variables
    
    @Published var charViewData: LineChartData!
    @Published var selectedCoin: CoinDataBaseModel!
    
    // MARK: - Internal functions
    
    func getChartDataForCoin() {
        if let coinPriceHistory = getCoinPriceHistoryForLast(seconds: 30) {
            
            let dataEntryValues = prepareDataEntryValues(priceHistory: coinPriceHistory)
            let dataSetForChart = prepareDataSetForChart(entryValues: dataEntryValues)
            charViewData = LineChartData(dataSet: dataSetForChart)
        }
    }
    
    // MARK: - Private functions
    
    private func getCoinPriceHistoryForLast(seconds: Int) -> [Double]? {
        
        if selectedCoin.coinPriceHistory.elements.count >= seconds {
            
            var values = [Double]()
            selectedCoin.coinPriceHistory.prefix(seconds).forEach { value in
                values.append(value)
            }
            
            return values
        }
        
        return nil
    }
    
    private func prepareDataEntryValues(priceHistory: [Double]) -> [ChartDataEntry] {
        
        var dataEntryValues = [ChartDataEntry]()
        
        for i in 0..<priceHistory.count {
            dataEntryValues.append(ChartDataEntry(x: Double(i), y: priceHistory[i]))
        }
        
        return dataEntryValues
    }
    
    private func prepareDataSetForChart(entryValues: [ChartDataEntry]) -> LineChartDataSet {
        
        let set = LineChartDataSet(entries: entryValues)
        
        set.drawCirclesEnabled = false
        set.drawCircleHoleEnabled = false
        set.drawFilledEnabled = false
        set.mode = .cubicBezier
        set.drawValuesEnabled = false
        set.lineWidth = 2
        set.setColor(.orange)
        
        let gradientColors = [UIColor.clear.cgColor, UIColor.orange.cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
        
        set.fillAlpha = 0.5
        set.fill = Fill(linearGradient: gradient, angle: 90)
        set.drawFilledEnabled = true
        
        
        return set
    }
}
