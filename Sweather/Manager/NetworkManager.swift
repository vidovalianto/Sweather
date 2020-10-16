//
//  NetworkManager.swift
//  Sweather
//
//  Created by Vido Shaweddy on 10/14/20.
//

import Combine
import UIKit

public enum Link {
    case cityLink(city: String)
    case coordinateLink(lat: String, lon: String)
    
    private static let base = "https://api.openweathermap.org/data/2.5/weather?"
    private static let appKey = URLQueryItem(name:"appid", value:"135770bcd37e66027735e6a3a26973cc")

    public var url: URL? {
        switch self {
        case .cityLink(let city):
            guard let base = URL(string: Link.base) else { return URL(string: Link.base) }
            let queryLocationToken = URLQueryItem(name:"q",
                                                  value:city)
            var components = URLComponents(url: base,
                                           resolvingAgainstBaseURL: false)
            components?.queryItems = [queryLocationToken, Link.appKey]
            guard let url = components?.url else { return base }
            return url
        case .coordinateLink(let lat, let lon):
            guard let base = URL(string: Link.base) else { return URL(string: Link.base) }
            let queryLatToken = URLQueryItem(name:"lat",
                                                  value:lat)
            let queryLonToken = URLQueryItem(name:"lon",
                                                  value:lon)
            var components = URLComponents(url: base,
                                           resolvingAgainstBaseURL: false)
            components?.queryItems = [queryLatToken, queryLonToken, Link.appKey]
            guard let url = components?.url else { return base }
            return url
        }
    }
}

private enum DataError: Error, CustomNSError {
    case invalidURL, invalidResponse, noData

    var localizedDescription: String {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .invalidResponse: return "Invalid response"
        case .noData: return "No data"
        }
    }

    var errorUserInfo: [String : Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }
}

public final class NetworkManager {
    public static let shared = NetworkManager()
    private let urlSession = URLSession.shared
    private var cancellable: AnyCancellable?

    private lazy var backgroundQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        return queue
    }()

    private init() {}

    public func fetch<D>(for link: Link, decoder: @escaping ((Data) throws -> D)) -> AnyPublisher<D, Error> {
        
        guard let url = link.url else {
            return Fail(error: DataError.invalidURL)
                .eraseToAnyPublisher()
        }

        return urlSession.dataTaskPublisher(for: url)
            .retry(3)
            .mapError({ error -> Error in
                switch error {
                case URLError.badURL:
                    return DataError.invalidURL
                case URLError.dataNotAllowed:
                    return DataError.noData
                default:
                    return error
                }
            })
            .map { $0.data }
            .tryMap { try decoder($0) }
            .subscribe(on: backgroundQueue)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
