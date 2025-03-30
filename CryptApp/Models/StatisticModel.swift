//
//  StatisticModel.swift
//  CryptApp
//
//  Created by Artem Golovchenko on 2025-03-29.
//

import Foundation

struct StatisticModel: Identifiable {
    
    let id = UUID().uuidString
    let title: String
    let value: String
    let percentage: Double?
    
    init(title: String, value: String, percentage: Double? = nil) {
        self.title = title
        self.value = value
        self.percentage = percentage
    }
}

