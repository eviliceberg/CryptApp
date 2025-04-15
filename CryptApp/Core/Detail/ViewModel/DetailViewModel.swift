//
//  DetailViewModel.swift
//  CryptApp
//
//  Created by Artem Golovchenko on 2025-04-09.
//

import Foundation
import Combine

final class DetailViewModel: ObservableObject {
    
    @Published var coin: CoinModel
    
    @Published var overviewStatistics: [StatisticModel] = []
    @Published var additionalStatistics: [StatisticModel] = []
    
    @Published var coinDescription: String? = nil
    @Published var webSiteURL: String? = nil
    @Published var redditURL: String? = nil
    
    private let coinDetailService: CoinDetailDataService
    
    init(coin: CoinModel) {
        self.coin = coin
        self.coinDetailService = CoinDetailDataService(coin: coin)
        addSubscribers()
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    private func addSubscribers() {
        coinDetailService.$coinDetails
            .combineLatest($coin)
            .map(mapDetails)
            .sink { [weak self] returnedArrays in
                self?.additionalStatistics = returnedArrays.additional
                self?.overviewStatistics = returnedArrays.overview
            }
            .store(in: &cancellables)
        
        coinDetailService.$coinDetails
            .sink { [weak self] details in
                self?.coinDescription = details?.readableDescription
                self?.redditURL = details?.links?.subredditURL
                self?.webSiteURL = details?.links?.homepage?.first
            }
            .store(in: &cancellables)
    }
    
    private func mapDetails(details: CoinDetailModel?, coin: CoinModel) -> (overview: [StatisticModel], additional: [StatisticModel]) {
        return (getOverview(coin: coin), getAdditionalData(coin: coin, details: details))
    }
    
    private func getOverview(coin: CoinModel) -> [StatisticModel] {
        let price = coin.currentPrice.asCurrencyWith6Decimals()
        let pricePercentChange = coin.priceChangePercentage24H
        let pricePercentStat = StatisticModel(title: "Current Price", value: price, percentage: pricePercentChange)
        
        let marketCap = "$" + (coin.marketCap?.formattedWithAbbreviations() ?? "")
        let capChange = coin.marketCapChangePercentage24H
        let marketStat = StatisticModel(title: "Market Capitalization", value: marketCap, percentage: capChange)
        
        let rank = "\(coin.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)
        
        let volume = "$" + (coin.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticModel(title: "Volume", value: volume)
        
        let overview: [StatisticModel] = [pricePercentStat, marketStat, rankStat, volumeStat]
        return overview
    }
    
    private func getAdditionalData(coin: CoinModel, details: CoinDetailModel?) -> [StatisticModel] {
        let high = coin.high24H?.asCurrencyWith6Decimals() ?? "n/a"
        let highStat = StatisticModel(title: "24H High", value: high)
        
        let low = coin.low24H?.asCurrencyWith6Decimals() ?? "n/a"
        let lowStat = StatisticModel(title: "24H Low", value: low)
        
        let priceChange = coin.priceChangePercentage24H?.asCurrencyWith6Decimals() ?? "n/a"
        let pricePercentChange2 = coin.priceChangePercentage24H
        let priceChangeStat = StatisticModel(title: "24H Price Change", value: priceChange, percentage: pricePercentChange2)
        
        let marketCapChange = "$" + (coin.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coin.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "24H Market Change", value: marketCapChange, percentage: marketCapPercentChange)
        
        let blockTime = details?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStat = StatisticModel(title: "Block Time", value: blockTimeString)
        
        let hashing = details?.hashingAlgorithm ?? "n/a"
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
        
        let additional: [StatisticModel] = [highStat, lowStat, priceChangeStat, marketCapStat, blockStat, hashingStat]
        return additional
    }
    
}
