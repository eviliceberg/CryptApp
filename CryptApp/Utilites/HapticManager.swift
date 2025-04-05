//
//  HapticManager.swift
//  CryptApp
//
//  Created by Artem Golovchenko on 2025-04-05.
//

import Foundation
import SwiftUI

final class HapticManager {
    
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
    
}
