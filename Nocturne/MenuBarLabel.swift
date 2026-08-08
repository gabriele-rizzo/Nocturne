//
//  MenuBarLabel.swift
//  Nocturne
//
//  Created by Gabriele Rizzo on 07/08/26.
//

import SwiftUI

struct MenuBarLabel: View {
    let manager: KeyboardBacklightManager

    var body: some View {
        Image(symbol)
    }
    
    private var symbol: String {
        guard let scheduler = manager.scheduler else { return "backlight.off.slash" }
        
        switch scheduler.activation.mode {
            case .on: return "backlight.always"
            case .off: return "backlight.off"
            case .solar: return "backlight.solar"
            case .custom: return "backlight.custom"
        }
    }
}
