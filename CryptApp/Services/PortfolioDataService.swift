//
//  PortfolioDataService.swift
//  CryptApp
//
//  Created by Artem Golovchenko on 2025-04-04.
//

import Foundation
import CoreData

final class PortfolioDataService {
    
    private let container: NSPersistentContainer
    private let containerName: String = "PortfolioContainer"
    private let entityName: String = "PortfolioEntity"
    
    @Published var savedEntities: [PortfolioEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading Core Data: \(error)")
            }
        }
        getPortfolio()
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        if let entity = savedEntities.first(where: { $0.coinId == coin.id }) {
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                delete(entity: entity)
            }
        } else {
            add(coin: coin, amount: amount)
        }
    }
    
    //MARK: - Private Section
    private func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch {
            print(error)
        }
    }
    
    private func update(entity: PortfolioEntity, amount: Double) {
        entity.amount = amount
        save()
    }
    
    private func delete(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        save()
    }
    
    private func add(coin: CoinModel, amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinId = coin.id
        entity.amount = amount
        
        save()
    }
    
    private func save() {
        do {
            try container.viewContext.save()
            getPortfolio()
        } catch {
            print(error)
        }
    }
    
}
