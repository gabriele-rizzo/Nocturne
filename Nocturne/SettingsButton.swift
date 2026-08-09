//
//  SettingsButton.swift
//  Nocturne
//
//  Created by Gabriele Rizzo on 09/08/26.
//

import SwiftUI

struct SettingsButton: View {
    static let window = "settings"

    @Environment(\.openWindow) private var openWindow

    var body: some View {
        Button("Settings…") {
            openWindow(id: Self.window)
            NSApplication.shared.activate()
        }
        .keyboardShortcut("s", modifiers: .command)
    }
}
