//
//  ActivationMode+Title.swift
//  Nocturne
//
//  Created by Gabriele Rizzo on 07/08/26.
//

import SwiftUI

extension ActivationMode {
    var title: LocalizedStringKey {
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
