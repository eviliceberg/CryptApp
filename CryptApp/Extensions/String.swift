//
//  String.swift
//  CryptApp
//
//  Created by Artem Golovchenko on 2025-04-15.
//

import Foundation

extension String {
    
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
}
