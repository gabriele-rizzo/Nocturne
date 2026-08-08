//
//  ActivationMode+Title.swift
//  Nocturne
//
//  Created by Gabriele Rizzo on 07/08/26.
//

extension ActivationMode {
    var title: String {
        switch self {
            case .on:
                return "Always on"
            case .off:
                return "Always off"
            case .solar:
                return "Sunset to sunrise"
            case .custom:
                return "Custom"
        }
    }
}
