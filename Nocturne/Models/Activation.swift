//
//  Activation.swift
//  Nocturne
//
//  Created by Gabriele Rizzo on 07/08/26.
//

struct Activation: Equatable, Codable {
    var mode: ActivationMode
    var window: DayWindow

    static let standard = Activation(
        mode: .on,
        window: DayWindow(start: DayTime(hour: 7, minute: 0)!, end: DayTime(hour: 22, minute: 0)!)
    )
}
