//
//  DetailViewModel.swift
//  CryptApp
//
//  Created by Artem Golovchenko on 2025-04-09.
//

import Foundation
import Combine

final class DetailViewModel: ObservableObject {
    
    @Published var coinDetails: CoinDetailModel? = nil
    
    private let coinDetailService: CoinDetailDataService
    
    init(coin: CoinModel) {
        self.coinDetailService = CoinDetailDataService(coin: coin)
        addSubscribers()
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    private func addSubscribers() {
        coinDetailService.$coinDetails
            .sink { [weak self] result in
                self?.coinDetails = result
            }
            .store(in: &cancellables)
    }
    
}
