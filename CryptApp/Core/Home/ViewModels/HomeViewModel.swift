//
//  HomeViewModel.swift
//  CryptApp
//
//  Created by Artem Golovchenko on 2025-03-27.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    
    @Published var coins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    
    private let dataService = CoinDataService()
    
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init() {
        getCoins()
        self.portfolioCoins.append(DeveloperPreview.instance.coin)
    }
    
    func getCoins() {
        dataService.$allCoins
            .sink { [weak self] allCoins in
                self?.coins = allCoins
            }
            .store(in: &cancellables)
    }
    
}
