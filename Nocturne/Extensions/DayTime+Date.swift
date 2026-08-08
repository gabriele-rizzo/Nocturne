//
//  DayTime+Date.swift
//  Nocturne
//
//  Created by Gabriele Rizzo on 07/08/26.
//

import Foundation

extension DayTime {
    init?(_ date: Date, calendar: Calendar = .current) {
        let parts = calendar.dateComponents([.hour, .minute], from: date)

        guard let hour = parts.hour, let minute = parts.minute else { return nil }

        self.init(hour: hour, minute: minute)
    }
}
