//
//  BacklightScheduleManager.swift
//  Nocturne
//
//  Created by Gabriele Rizzo on 07/08/26.
//

import AppKit
import Observation

@MainActor
@Observable
final class BacklightScheduleManager {
    var activation: Activation {
        didSet {
            guard activation != oldValue else { return }

            Self.stored = activation
            evaluate()
        }
    }

    var coordinate: Coordinate? {
        didSet {
            guard coordinate != oldValue else { return }

            evaluate()
        }
    }

    private(set) var isForcingOff = false

    var needsLocation: Bool { activation.mode == .solar && coordinate == nil }

    private static let fadeMilliseconds: Int32 = 500
    private static let key = "activation"
    private static let holdKey = "hold"

    private static var hold: Double? {
        get { UserDefaults.standard.object(forKey: holdKey) as? Double }
        set {
            guard let newValue else { return UserDefaults.standard.removeObject(forKey: holdKey) }

            UserDefaults.standard.set(newValue, forKey: holdKey)
        }
    }

    private static var stored: Activation {
        get {
            guard let data = UserDefaults.standard.data(forKey: key),
                  let value = try? JSONDecoder().decode(Activation.self, from: data)
            else { return .standard }

            return value
        }
        set {
            UserDefaults.standard.set(try? JSONEncoder().encode(newValue), forKey: key)
        }
    }

    @ObservationIgnored
    private let backlight: KeyboardBacklightController

    @ObservationIgnored
    private var timer: Timer?

    @ObservationIgnored
    private var restoreLevel: Double?

    @ObservationIgnored
    private var observers: [(center: NotificationCenter, token: any NSObjectProtocol)] = []

    init(_ backlight: KeyboardBacklightController, coordinate: Coordinate? = nil) {
        self.backlight = backlight
        self.coordinate = coordinate
        self.activation = Self.stored
        self.restoreLevel = Self.hold
        self.isForcingOff = Self.hold != nil

        observeSystemEvents()
        evaluate()
    }

    deinit {
        timer?.invalidate()

        for observer in observers {
            observer.center.removeObserver(observer.token)
        }
    }

    func evaluate(now: Date = Date()) {
        switch suppression(now) {
        case .never:
            release()
        case .always:
            forceOff()
        case .during(let window):
            if window.contains(now) { forceOff() } else { release() }
        }

        armNextEvaluation(after: now)
    }

    private func suppression(_ date: Date) -> Suppression {
        activation.suppression(on: date, at: coordinate)
    }

    private func forceOff() {
        guard !isForcingOff else { return }

        restoreLevel = backlight.get()
        Self.hold = restoreLevel
        backlight.set(0, fadeMilliseconds: Self.fadeMilliseconds)
        isForcingOff = true
    }

    private func release() {
        guard isForcingOff else { return }

        if let restoreLevel {
            backlight.set(restoreLevel, fadeMilliseconds: Self.fadeMilliseconds)
        }

        restoreLevel = nil
        Self.hold = nil
        isForcingOff = false
    }

    private func armNextEvaluation(after date: Date) {
        timer?.invalidate()
        timer = nil

        guard case .during(let window) = suppression(date),
              let boundary = window.nextBoundary(after: date)
        else { return }

        let timer = Timer(fire: boundary, interval: 0, repeats: false) { [weak self] _ in
            MainActor.assumeIsolated { self?.evaluate() }
        }

        RunLoop.main.add(timer, forMode: .common)
        self.timer = timer
    }

    private func observeSystemEvents() {
        let workspace = NSWorkspace.shared.notificationCenter
        let system = NotificationCenter.default

        let events: [(NotificationCenter, Notification.Name)] = [
            (workspace, NSWorkspace.didWakeNotification),
            (system, NSNotification.Name.NSSystemClockDidChange),
            (system, NSNotification.Name.NSSystemTimeZoneDidChange),
        ]

        observers = events.map { center, name in
            let token = center.addObserver(forName: name, object: nil, queue: .main) { [weak self] _ in
                MainActor.assumeIsolated { self?.evaluate() }
            }

            return (center, token)
        }

        let termination = system.addObserver(forName: NSApplication.willTerminateNotification, object: nil, queue: nil) { [weak self] _ in
            MainActor.assumeIsolated { self?.release() }
        }

        observers.append((system, termination))
    }
}
