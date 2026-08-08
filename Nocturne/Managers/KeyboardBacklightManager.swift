//
//  KeyboardBacklightManager.swift
//  Nocturne
//
//  Created by Gabriele Rizzo on 07/08/26.
//

import Observation

@MainActor
@Observable
final class KeyboardBacklightManager {
    @ObservationIgnored
    private let controller = KeyboardBacklightController()

    @ObservationIgnored
    private(set) var scheduler: BacklightScheduleManager?

    @ObservationIgnored
    let location = LocationManager()

    init() {
        scheduler = controller.map { BacklightScheduleManager($0, coordinate: location.coordinate) }
        location.onUpdate = { [weak self] in self?.scheduler?.coordinate = $0 }

        if scheduler?.activation.mode == .solar {
            location.request()
        }

        location.refresh()
    }
}
