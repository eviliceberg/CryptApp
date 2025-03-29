//
//  UIApplication.swift
//  CryptApp
//
//  Created by Artem Golovchenko on 2025-03-29.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
