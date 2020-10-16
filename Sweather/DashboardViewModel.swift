//
//  DashboardViewModel.swift
//  Sweather
//
//  Created by Vido Shaweddy on 10/14/20.
//

import Combine
import Foundation
import UIKit

public class DashboardViewModel: ObservableObject {
    public static let shared = DashboardViewModel()
    private let locationManager = LocationManager.shared
    private let networkManager = NetworkManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    @Published var weathers: RespondWeather? = nil
    @Published var curLocation: String? = nil
    
    private init() {
        locationManager.$latestCoordinate.sink { [weak self] cord in
            guard let (lat,lon) = cord else { return }
            self?.networkManager.fetch(for: .coordinateLink(lat: lat, lon: lon)) {
                try JSONDecoder().decode(RespondWeather.self, from: $0)
            }.sink { result in
                print(result)
            } receiveValue: { [weak self] (models) in
                self?.weathers = models
            }
        }.store(in: &cancellables)
        
        locationManager.$latestPlacemark.sink { [weak self] placemark in
            guard let location = placemark else { return }
            self?.curLocation = location.displayString
        }.store(in: &cancellables)
    }
}


