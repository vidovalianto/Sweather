//
//  LocationManager.swift
//  Sweather
//
//  Created by Vido Shaweddy on 10/14/20.
//

import Combine
import CoreData
import Foundation
import MapKit

public final class LocationManager: NSObject, ObservableObject {
    public static let shared = LocationManager()
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    @Published
    private(set) var latestPlacemark: CLPlacemark? = nil
    @Published
    private(set) var latestCoordinate: (String, String)? = nil
    
    private override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        self.locationManager.requestLocation()
    }
    
    fileprivate func updatePlacemark(for location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let placemark = placemarks?.first {
                self?.latestPlacemark = placemark
            }
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.requestLocation()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            self.latestCoordinate = (location.coordinate.latitude.displayString, location.coordinate.longitude.displayString)
            updatePlacemark(for: location)
        }
    }
}

extension CLLocationDegrees {
    var displayString: String {
        return "\(self)"
    }
}

extension CLPlacemark {
    var displayString: String {
        guard let name = self.name,
              let subArea = self.subAdministrativeArea,
              let adminArea = self.administrativeArea,
              let postalCode = self.postalCode
        else { return "Searching for location" }
        
        return "\(name) - \(subArea) - \(adminArea) - \(postalCode)"
    }
}
