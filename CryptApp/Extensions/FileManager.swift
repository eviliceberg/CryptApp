//
//  FileManager.swift
//  CryptApp
//
//  Created by Artem Golovchenko on 2025-03-29.
//

import Foundation

extension FileManager {
    
    static var cacheDirectory: URL {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}
