//
//  HomeViewModel.swift
//  CryptApp
//
//  Created by Artem Golovchenko on 2025-03-27.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    @Published var stats: [StatisticModel] = []
    
    @Published var coins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    
    @Published var searchText: String = ""
    
    @Published var isLoading: Bool = false
    
    private let coinDataService = CoinDataService()
    
    private let marketDataService = MarketDataService()
    
    private let portfolioDataService = PortfolioDataService()
    
    private let path = FileManager.cacheDirectory.appending(path: "photosCache")
    
    //private var allCoins: [CoinModel] = []
    
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init() {
        //checkCache()
        //getCoins()
        filterCoins()
        getPortfolioCoins()
        getMarketData()
    }
    
    func getPortfolioCoins() {
        portfolioDataService.$savedEntities
            .combineLatest($coins)
            .map { (portfolio, allCoins) -> [CoinModel] in
                var result: [CoinModel] = []
                
                for item in portfolio {
                    if var firstCoin = allCoins.first(where: { $0.id == item.coinId }) {
                        result.append(firstCoin.updateHoldings(amount: item.amount))
                    }
                }
                return result
            }
            .sink { [weak self] portCoins in
                self?.portfolioCoins = portCoins
            }
            .store(in: &cancellables)
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func filterCoins() {
        $searchText
            .combineLatest(coinDataService.$allCoins)
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { [weak self] (searchText, allCoins) in
                guard let self = self else { return }
                
                self.coins = allCoins
                
                if !searchText.isEmpty {
                    self.coins = self.coins.filter { $0.symbol.localizedCaseInsensitiveContains(searchText) || $0.name.localizedCaseInsensitiveContains(searchText) }
                }
                
            }
            .store(in: &cancellables)
    }
    
    func getMarketData() {
        marketDataService.$allData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink(receiveValue: { [weak self] item in
                self?.stats = item
                self?.isLoading = false
            })
            .store(in: &cancellables)
    }
    
    func getCoins() {
        coinDataService.$allCoins
            .receive(on: DispatchQueue.main)
            .sink { [weak self] allCoins in
                self?.coins = allCoins
                guard let self = self else { return }
                LocalFileManager.saveToFileManager(data: allCoins, path: path)
                print("successfully saved data")
            }
            .store(in: &cancellables)
    }
    
    func checkCache() {
        do {
            let coins = try LocalFileManager.retrieveFromFileManager(path: path, type: [CoinModel].self)
            if !coins.isEmpty {
                self.coins = coins
            }
            print("data from cache")
        } catch {
            print("no cache")
        }
    }
    
    private func mapGlobalMarketData(data: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        
        guard let data = data else { return stats }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentage: data.marketCapChangePercentage24HUsd)
        
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        
        let dominance = StatisticModel(title: "Bitcoin Dominance", value: data.btcDominance)
        
        let portfolioValue =
            portfolioCoins
                .map({ $0.currentHoldingsValue })
                .reduce(0, +)
        
        let previousValue = portfolioCoins.map { coin -> Double in
            let currentValue = coin.currentHoldingsValue
            let percentChange = coin.priceChangePercentage24H ?? 0.0 / 100
            let previousValue = currentValue / (1 + percentChange)
            return previousValue
        }
        .reduce(0, +)
        
        let percent = ((portfolioValue / previousValue) - 1) * 100
        
        let portfolio = StatisticModel(title: "Portfolio Value", value: portfolioValue.asCurrencyWith2Decimals(), percentage: percent)
        
        stats.append(contentsOf: [marketCap, volume, dominance, portfolio])
        
        return stats
    }
    
    func reloadData() {
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getMarketData()
        HapticManager.notification(type: .success)
    }
    
}
