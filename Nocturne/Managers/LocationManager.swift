//
//  LocationManager.swift
//  Nocturne
//
//  Created by Gabriele Rizzo on 07/08/26.
//

import CoreLocation
import Observation

@MainActor
@Observable
final class LocationManager: NSObject, CLLocationManagerDelegate {
    private(set) var coordinate: Coordinate?
    private(set) var authorization: CLAuthorizationStatus

    var available: Bool {
        authorization == .authorizedAlways
    }

    var denied: Bool {
        authorization == .denied || authorization == .restricted
    }

    @ObservationIgnored
    var onUpdate: ((Coordinate) -> Void)?

    @ObservationIgnored
    private let manager = CLLocationManager()

    @ObservationIgnored
    private static let key = "coordinate"

    private static var stored: Coordinate? {
        get {
            guard let data = UserDefaults.standard.data(forKey: key) else { return nil }

            return try? JSONDecoder().decode(Coordinate.self, from: data)
        }
        set {
            UserDefaults.standard.set(try? JSONEncoder().encode(newValue), forKey: key)
        }
    }

    override init() {
        authorization = .notDetermined
        coordinate = Self.stored

        super.init()

        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        authorization = manager.authorizationStatus
    }

    func request() {
        manager.requestWhenInUseAuthorization()
    }

    func refresh() {
        guard available else { return }

        manager.requestLocation()
    }

    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        MainActor.assumeIsolated {
            authorization = manager.authorizationStatus
            refresh()
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let last = locations.last else { return }

        MainActor.assumeIsolated {
            let value = Coordinate(latitude: last.coordinate.latitude, longitude: last.coordinate.longitude)

            coordinate = value
            Self.stored = value
            onUpdate?(value)
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {}
}
