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
    
    @Published var searchText: String = ""
    
    private let dataService = CoinDataService()
    
    private let path = FileManager.cacheDirectory.appending(path: "photosCache")
    
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init() {
        if checkCache() {
            self.portfolioCoins.append(DeveloperPreview.instance.coin)
        } else {
            getCoins()
            self.portfolioCoins.append(DeveloperPreview.instance.coin)
        }
        
    }
    
    func getCoins() {
        dataService.$allCoins
            .sink { [weak self] allCoins in
                self?.coins = allCoins
                guard let self = self else { return }
                LocalFileManager.saveToFileManager(data: allCoins, path: self.path)
                
            }
            .store(in: &cancellables)
    }
    
    func checkCache() -> Bool {
        do {
            let coins = try LocalFileManager.retrieveFromFileManager(path: self.path, type: [CoinModel].self)
            
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
