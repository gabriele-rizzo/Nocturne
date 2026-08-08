//
//  SuppressionTests.swift
//  NocturneTests
//
//  Created by Gabriele Rizzo on 07/08/26.
//

import XCTest
@testable import Nocturne

final class SuppressionTests: XCTestCase {
    private let rome = Coordinate(latitude: 41.9028, longitude: 12.4964)
    private let oslo = Coordinate(latitude: 59.9139, longitude: 10.7522)
    private let tromso = Coordinate(latitude: 69.6496, longitude: 18.9560)
    private let cape = Coordinate(latitude: -33.9249, longitude: 18.4241)
    private let quito = Coordinate(latitude: -0.1807, longitude: -78.4678)
    private let svalbard = Coordinate(latitude: 78.2232, longitude: 15.6469)

    private var utc: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }

    private func day(_ year: Int, _ month: Int, _ day: Int) -> Date {
        utc.date(from: DateComponents(timeZone: utc.timeZone, year: year, month: month, day: day, hour: 12))!
    }

    private func window(_ date: Date, _ coordinate: Coordinate) -> DayWindow? {
        guard case .during(let window) = Suppression.solar(on: date, at: coordinate, calendar: utc) else { return nil }
        return window
    }

    private func minutes(_ time: DayTime) -> Double { Double(time.minutesSinceMidnight) }

    private func assertCivil(
        _ coordinate: Coordinate, _ date: Date, _ begin: Double, _ end: Double,
        _ label: String, line: UInt = #line
    ) {
        guard let window = window(date, coordinate) else {
            return XCTFail("\(label): expected a window", line: line)
        }

        XCTAssertEqual(minutes(window.start), begin, accuracy: 2, "\(label) dawn", line: line)
        XCTAssertEqual(minutes(window.end), end, accuracy: 2, "\(label) dusk", line: line)
    }

    func testCivilTwilightMatchesPublishedTimes() {
        assertCivil(rome, day(2026, 6, 21), 180.5, 1163.1, "Rome Jun")
        assertCivil(rome, day(2026, 12, 21), 362.6, 973.5, "Rome Dec")
        assertCivil(rome, day(2026, 3, 20), 285.4, 1069.6, "Rome Mar")
        assertCivil(oslo, day(2026, 6, 21), 9.7, 1347.9, "Oslo Jun")
        assertCivil(oslo, day(2026, 12, 21), 440.6, 909.5, "Oslo Dec")
        assertCivil(tromso, day(2026, 12, 21), 511.2, 773.2, "Tromso Dec")
        assertCivil(cape, day(2026, 6, 21), 323.6, 972.6, "CapeTown Jun")
        assertCivil(cape, day(2026, 12, 21), 182.8, 1105.9, "CapeTown Dec")
        assertCivil(quito, day(2026, 6, 21), 649.9, 1421.6, "Quito Jun")
        assertCivil(quito, day(2026, 3, 20), 657.3, 1425.3, "Quito Mar")
    }

    func testMidnightSunSuppressesAlways() {
        XCTAssertEqual(Suppression.solar(on: day(2026, 6, 21), at: tromso, calendar: utc), .always)
        XCTAssertEqual(Suppression.solar(on: day(2026, 6, 21), at: svalbard, calendar: utc), .always)
    }

    func testPolarNightSuppressesNever() {
        XCTAssertEqual(Suppression.solar(on: day(2026, 12, 21), at: svalbard, calendar: utc), .never)
    }

    func testCivilTwilightIsWiderThanSunriseSunset() {
        guard case .during(let civil) = Suppression.solar(on: day(2026, 6, 21), at: quito, calendar: utc),
              case .during(let plain) = Suppression.solar(
                on: day(2026, 6, 21), at: quito, zenith: SolarZenith(degrees: 90.833), calendar: utc)
        else { return XCTFail("expected windows") }

        XCTAssertLessThan(minutes(civil.start), minutes(plain.start))
        XCTAssertGreaterThan(minutes(civil.end), minutes(plain.end))
    }

    func testActivationResolvesEachMode() {
        let custom = DayWindow(start: DayTime(hour: 9, minute: 30)!, end: DayTime(hour: 18, minute: 0)!)
        let date = day(2026, 6, 21)

        XCTAssertEqual(Activation(mode: .on, window: custom).suppression(on: date, at: rome, calendar: utc), .never)
        XCTAssertEqual(Activation(mode: .off, window: custom).suppression(on: date, at: rome, calendar: utc), .always)
        XCTAssertEqual(Activation(mode: .custom, window: custom).suppression(on: date, at: nil, calendar: utc), .during(custom))
        XCTAssertEqual(Activation(mode: .solar, window: custom).suppression(on: date, at: nil, calendar: utc), .never)
    }

    func testActivationRoundTripsThroughJSON() throws {
        let custom = DayWindow(start: DayTime(hour: 9, minute: 30)!, end: DayTime(hour: 18, minute: 0)!)

        for mode in ActivationMode.allCases {
            let original = Activation(mode: mode, window: custom)
            let data = try JSONEncoder().encode(original)

            XCTAssertEqual(try JSONDecoder().decode(Activation.self, from: data), original, "\(mode)")
        }
    }
}
