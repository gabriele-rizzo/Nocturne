//
//  DayWindowTests.swift
//  NocturneTests
//
//  Created by Gabriele Rizzo on 07/08/26.
//

import XCTest
@testable import Nocturne

final class DayWindowTests: XCTestCase {
    private func time(_ hour: Int, _ minute: Int = 0) -> DayTime {
        DayTime(hour: hour, minute: minute)!
    }

    private func window(_ start: Int, _ end: Int) -> DayWindow {
        DayWindow(start: time(start), end: time(end))
    }

    private var rome: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Europe/Rome")!
        return calendar
    }

    private func date(_ string: String) -> Date {
        let formatter = DateFormatter()
        formatter.calendar = rome
        formatter.timeZone = rome.timeZone
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.date(from: string)!
    }

    func testRejectsImpossibleTimes() {
        XCTAssertNil(DayTime(hour: 24, minute: 0))
        XCTAssertNil(DayTime(hour: 0, minute: 60))
        XCTAssertNil(DayTime(hour: -1, minute: 0))
    }

    func testContainsIsHalfOpen() {
        let day = window(9, 17)

        XCTAssertFalse(day.contains(time(8, 59)))
        XCTAssertTrue(day.contains(time(9)))
        XCTAssertTrue(day.contains(time(16, 59)))
        XCTAssertFalse(day.contains(time(17)))
    }

    func testContainsAcrossMidnight() {
        let night = window(22, 7)

        XCTAssertTrue(night.wrapsMidnight)
        XCTAssertFalse(night.contains(time(21, 59)))
        XCTAssertTrue(night.contains(time(22)))
        XCTAssertTrue(night.contains(time(23, 59)))
        XCTAssertTrue(night.contains(time(0)))
        XCTAssertTrue(night.contains(time(6, 59)))
        XCTAssertFalse(night.contains(time(7)))
        XCTAssertFalse(night.contains(time(12)))
    }

    func testEmptyWindowContainsNothing() {
        let empty = window(22, 22)

        XCTAssertTrue(empty.isEmpty)
        XCTAssertFalse(empty.contains(time(22)))
        XCTAssertNil(empty.nextBoundary(after: date("2026-06-10 12:00"), calendar: rome))
    }

    func testNextBoundaryPicksTheNearerEdge() {
        let night = window(22, 7)
        let calendar = rome

        XCTAssertEqual(night.nextBoundary(after: date("2026-06-10 12:00"), calendar: calendar), date("2026-06-10 22:00"))
        XCTAssertEqual(night.nextBoundary(after: date("2026-06-10 22:00"), calendar: calendar), date("2026-06-11 07:00"))
        XCTAssertEqual(night.nextBoundary(after: date("2026-06-10 23:30"), calendar: calendar), date("2026-06-11 07:00"))
        XCTAssertEqual(night.nextBoundary(after: date("2026-06-11 03:00"), calendar: calendar), date("2026-06-11 07:00"))
        XCTAssertEqual(night.nextBoundary(after: date("2026-06-11 07:00"), calendar: calendar), date("2026-06-11 22:00"))
    }

    func testNextBoundarySurvivesSpringForward() {
        let skipped = window(2, 9)

        XCTAssertEqual(
            skipped.nextBoundary(after: date("2026-03-29 01:00"), calendar: rome),
            date("2026-03-29 03:00")
        )
    }
}
