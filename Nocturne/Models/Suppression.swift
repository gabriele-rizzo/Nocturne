//
//  Suppression.swift
//  Nocturne
//
//  Created by Gabriele Rizzo on 07/08/26.
//

enum Suppression: Equatable {
    case never
    case always
    case during(DayWindow)
}
