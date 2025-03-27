//
//  CoinDataService.swift
//  CryptApp
//
//  Created by Artem Golovchenko on 2025-03-27.
//

import Foundation
import Combine

final class CoinDataService {
    
    @Published var allCoins: [CoinModel] = []
    
    var coinCancellable: AnyCancellable?
    
    init() {
        getCoins()
    }
    
    private func getCoins() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&sparkline=true&price_change_percentage=24h&precision=2") else { return }
        
        coinCancellable = NetworkingManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] result in
                self?.allCoins = result
                self?.coinCancellable?.cancel()
            })
        
    }
    
}
