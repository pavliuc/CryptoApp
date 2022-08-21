//
//  MainViewControllerUI.swift
//  CryptoApp
//
//  Created by Cristian Pavliuc on 19.08.2022.
//

import Foundation
import UIKit
import SnapKit

final class MainViewControllerUI {
    
    // MARK: - Private variables
    
    private var viewController: UIViewController!
    
    // MARK: - UI Elements
    
    lazy var coinsCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .white
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(CoinCollectionViewCell.self,
                                forCellWithReuseIdentifier: CoinCollectionViewCell.cellIdentifier)
        
        return collectionView
    }()
    
    // MARK: - Lifecycle
    
    init(viewController: UIViewController) {
        
        self.viewController = viewController
        coinsCollectionView.delegate = viewController as? UICollectionViewDelegate
    }
    
    // MARK: - Internal functions
    
    func setViewControllerTitle(title: String) {
        viewController.title = title
    }
    
    func setupLayout(for view: UIView) {
        
        view.backgroundColor = .white
        view.addSubview(coinsCollectionView)
        
        coinsCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func reloadCollectionViewData() {
        coinsCollectionView.reloadData()
    }
}
