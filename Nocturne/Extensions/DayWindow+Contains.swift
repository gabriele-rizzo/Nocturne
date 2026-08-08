//
//  DayWindow+Contains.swift
//  Nocturne
//
//  Created by Gabriele Rizzo on 07/08/26.
//

import Foundation

extension DayWindow {
    func contains(_ time: DayTime) -> Bool {
        guard !isEmpty else { return false }

        let t = time.minutesSinceMidnight
        let s = start.minutesSinceMidnight
        let e = end.minutesSinceMidnight

        return wrapsMidnight ? (t >= s || t < e) : (t >= s && t < e)
    }
    
    func contains(_ date: Date, calendar: Calendar = .current) -> Bool {
        let parts = calendar.dateComponents([.hour, .minute], from: date)

        guard let hour = parts.hour,
              let minute = parts.minute,
              let time = DayTime(hour: hour, minute: minute)
        else { return false }

        return contains(time)
    }
}
