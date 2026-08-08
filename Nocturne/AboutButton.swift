//
//  AboutButton.swift
//  Nocturne
//
//  Created by Gabriele Rizzo on 09/08/26.
//

import SwiftUI

struct AboutButton: View {
    static let window = "about"

    @Environment(\.openWindow) private var openWindow

    var body: some View {
        Button("About Nocturne") {
            openWindow(id: Self.window)
            NSApplication.shared.activate()
        }
    }
}
