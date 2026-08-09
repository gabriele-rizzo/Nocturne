//
//  DayTime+Steps.swift
//  Nocturne
//
//  Created by Gabriele Rizzo on 09/08/26.
//

import Foundation

extension DayTime {
    static let step = 30

    static let steps: [DayTime] = stride(from: 0, to: 24 * 60, by: step).compactMap {
        DayTime(minutesSinceMidnight: $0)
    }

    init?(minutesSinceMidnight minutes: Int) {
        self.init(hour: minutes / 60, minute: minutes % 60)
    }
}
