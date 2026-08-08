//
//  DayWindow+NextBoundary.swift
//  Nocturne
//
//  Created by Gabriele Rizzo on 07/08/26.
//

import Foundation

extension DayWindow {
    func nextBoundary(after date: Date, calendar: Calendar = .current) -> Date? {
        guard !isEmpty else { return nil }

        return [start, end].compactMap { time in calendar.nextDate(
            after: date,
            matching: DateComponents(hour: time.hour, minute: time.minute, second: 0),
            matchingPolicy: .nextTime,
            repeatedTimePolicy: .first,
            direction: .forward
        )}.min()
    }
}
