//
//  DayTime.swift
//  Nocturne
//
//  Created by Gabriele Rizzo on 07/08/26.
//

struct DayTime: Equatable, Comparable, Codable {
    let hour: Int
    let minute: Int

    init?(hour: Int, minute: Int) {
        guard (0..<24).contains(hour), (0..<60).contains(minute) else { return nil }

        self.hour = hour
        self.minute = minute
    }

    var minutesSinceMidnight: Int { hour * 60 + minute }

    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.minutesSinceMidnight < rhs.minutesSinceMidnight
    }
}
