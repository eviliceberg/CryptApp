//
//  NetworkingManager.swift
//  CryptApp
//
//  Created by Artem Golovchenko on 2025-03-27.
//

import Foundation
import Combine

enum NetworkingError: LocalizedError {
    case badURLResponse(url: URL)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .badURLResponse(url: let url):
            return "Bad URL response: \(url)"
        case .unknown:
            return "Unknown error occured"
        }
    }
}

final class NetworkingManager {
    
    static func download(url: URL) -> AnyPublisher<Data, any Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
//            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap( { try handleURLSession(output: $0, url: url) } )
            .retry(3)
            .eraseToAnyPublisher()
    }
    
    static func handleURLSession(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse , response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkingError.badURLResponse(url: url)
        }
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let failure):
            print(failure.localizedDescription)
        }
    }
    
}
