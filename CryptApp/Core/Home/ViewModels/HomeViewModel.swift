//
//  HomeViewModel.swift
//  CryptApp
//
//  Created by Artem Golovchenko on 2025-03-27.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    @Published var stats: [StatisticModel] = [
        StatisticModel(title: "Title", value: "Value", percentage: 1),
        StatisticModel(title: "Title", value: "Value"),
        StatisticModel(title: "Title", value: "Value"),
        StatisticModel(title: "Title", value: "Value", percentage: -7)
    ]
    
    @Published var coins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    
    @Published var searchText: String = ""
    
    private let dataService = CoinDataService()
    
    private let path = FileManager.cacheDirectory.appending(path: "photosCache")
    
    //private var allCoins: [CoinModel] = []
    
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init() {
        if checkCache() {
            self.portfolioCoins.append(DeveloperPreview.instance.coin)
        } else {
            getCoins()
            self.portfolioCoins.append(DeveloperPreview.instance.coin)
        }
        filterCoins()
    }
    
    func filterCoins() {
        $searchText
            .combineLatest(dataService.$allCoins)
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
    
    func getCoins() {
        dataService.$allCoins
            .sink { [weak self] allCoins in
                self?.coins = allCoins
                guard let self = self else { return }
                LocalFileManager.saveToFileManager(data: allCoins, path: path)
                print("successfully saved data")
            }
            .store(in: &cancellables)
    }
    
    func checkCache() -> Bool {
        do {
            let coins = try LocalFileManager.retrieveFromFileManager(path: path, type: [CoinModel].self)
            if coins.isEmpty {
                return false
            } else {
                self.coins = coins
            }
            print("data from cache")
            return true
        } catch {
            return false
        }
    }
    
}
