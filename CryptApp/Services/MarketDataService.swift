//
//  MarketDataService.swift
//  CryptApp
//
//  Created by Artem Golovchenko on 2025-04-02.
//

import Foundation
import Combine

final class MarketDataService {
    
    @Published var allData: MarketDataModel? = nil
    
    var marketDataCancellable: AnyCancellable?
    
    init() {
        getMarketData()
    }
    
    func getMarketData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
        
        marketDataCancellable = NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] result in
                self?.allData = result.data
                self?.marketDataCancellable?.cancel()
            })
        
    }
    
}
