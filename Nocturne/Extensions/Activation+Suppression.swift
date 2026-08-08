//
//  Activation+Suppression.swift
//  Nocturne
//
//  Created by Gabriele Rizzo on 07/08/26.
//

import Foundation

extension Activation {
    func suppression(on date: Date, at coordinate: Coordinate?, calendar: Calendar = .current) -> Suppression {
        switch mode {
            case .on:
                return .never
            case .off:
                return .always
            case .solar:
                guard let coordinate else { return .never }

                return .solar(on: date, at: coordinate, calendar: calendar)
            case .custom:
                return .during(window)
        }
    }
}
