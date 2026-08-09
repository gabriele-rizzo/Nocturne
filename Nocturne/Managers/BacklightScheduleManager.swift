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

    @ObservationIgnored
    private var isForcingOff = false

    var preventsDimming: Bool {
        didSet {
            guard preventsDimming != oldValue else { return }

            Self.storedPreventsDimming = preventsDimming
            applyDimming()
        }
    }

    private(set) var pausedUntil: Date?

    var paused: Bool { pausedUntil != nil }

    var needsLocation: Bool { activation.mode == .solar && coordinate == nil }

    private static let fadeMilliseconds: Int32 = 500
    private static let fallbackLevel = 0.5
    private static let key = "activation"
    private static let holdKey = "hold"
    private static let dimKey = "preventsDimming"
    private static let dimHoldKey = "dimHold"
    private static let autoHoldKey = "autoHold"

    private static var hold: Double? {
        get { UserDefaults.standard.object(forKey: holdKey) as? Double }
        set {
            guard let newValue else { return UserDefaults.standard.removeObject(forKey: holdKey) }

            UserDefaults.standard.set(newValue, forKey: holdKey)
        }
    }

    private static var storedPreventsDimming: Bool {
        get { UserDefaults.standard.bool(forKey: dimKey) }
        set { UserDefaults.standard.set(newValue, forKey: dimKey) }
    }

    private static var dimHold: Double? {
        get { UserDefaults.standard.object(forKey: dimHoldKey) as? Double }
        set {
            guard let newValue else { return UserDefaults.standard.removeObject(forKey: dimHoldKey) }

            UserDefaults.standard.set(newValue, forKey: dimHoldKey)
        }
    }

    private static var autoHold: Bool? {
        get { UserDefaults.standard.object(forKey: autoHoldKey) as? Bool }
        set {
            guard let newValue else { return UserDefaults.standard.removeObject(forKey: autoHoldKey) }

            UserDefaults.standard.set(newValue, forKey: autoHoldKey)
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
        self.preventsDimming = Self.storedPreventsDimming

        observeSystemEvents()
        applyDimming()
        evaluate()
    }

    deinit {
        timer?.invalidate()

        for observer in observers {
            observer.center.removeObserver(observer.token)
        }
    }

    func pause(for interval: TimeInterval, now: Date = Date()) {
        pausedUntil = now.addingTimeInterval(interval)
        evaluate(now: now)
    }

    func resume(now: Date = Date()) {
        pausedUntil = nil
        evaluate(now: now)
    }

    func evaluate(now: Date = Date()) {
        if let until = pausedUntil, until <= now { pausedUntil = nil }

        if paused {
            release()
        } else {
            switch suppression(now) {
            case .never:
                release()
            case .always:
                forceOff()
            case .during(let window):
                if window.contains(now) { forceOff() } else { release() }
            }
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

        if Self.autoHold == nil { Self.autoHold = backlight.autoBrightness }

        backlight.autoBrightness = false
        backlight.set(0, fadeMilliseconds: Self.fadeMilliseconds)
        isForcingOff = true
    }

    private func release() {
        guard isForcingOff else { return }

        if backlight.get() ?? 0 <= 0 {
            backlight.set(recoveredLevel, fadeMilliseconds: Self.fadeMilliseconds)
        }

        if let held = Self.autoHold { backlight.autoBrightness = held }

        Self.autoHold = nil
        restoreLevel = nil
        Self.hold = nil
        isForcingOff = false
    }

    private var recoveredLevel: Double {
        guard let restoreLevel, restoreLevel > 0 else { return Self.fallbackLevel }

        return restoreLevel
    }

    private func applyDimming() {
        guard preventsDimming else {
            if let held = Self.dimHold { backlight.idleDimTime = held }

            return Self.dimHold = nil
        }

        if Self.dimHold == nil { Self.dimHold = backlight.idleDimTime }

        backlight.idleDimTime = 0
    }

    private func restoreSystemState() {
        release()

        guard let held = Self.dimHold else { return }

        backlight.idleDimTime = held
        Self.dimHold = nil
    }

    private func armNextEvaluation(after date: Date) {
        timer?.invalidate()
        timer = nil

        guard let boundary = nextBoundary(after: date) else { return }

        let timer = Timer(fire: boundary, interval: 0, repeats: false) { [weak self] _ in
            MainActor.assumeIsolated { self?.evaluate() }
        }

        RunLoop.main.add(timer, forMode: .common)
        self.timer = timer
    }

    private func nextBoundary(after date: Date) -> Date? {
        if let pausedUntil { return pausedUntil }

        guard case .during(let window) = suppression(date) else { return nil }

        return window.nextBoundary(after: date)
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
            MainActor.assumeIsolated { self?.restoreSystemState() }
        }

        observers.append((system, termination))
    }
}
