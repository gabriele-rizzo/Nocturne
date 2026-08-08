//
//  DayWindow.swift
//  Nocturne
//
//  Created by Gabriele Rizzo on 07/08/26.
//

import Foundation

struct DayWindow: Equatable, Codable {
    let start: DayTime
    let end: DayTime

    init(start: DayTime, end: DayTime) {
        self.start = start
        self.end = end
    }

    var wrapsMidnight: Bool { end < start }
    var isEmpty: Bool { start == end }
}
