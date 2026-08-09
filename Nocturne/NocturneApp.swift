//
//  NocturneApp.swift
//  Nocturne
//
//  Created by Gabriele Rizzo on 07/08/26.
//

import SwiftUI

@main
struct NocturneApp: App {
    @State private var manager = KeyboardBacklightManager()

    private let updates = UpdateManager.shared

    var body: some Scene {
        MenuBarExtra {
            if let scheduler = manager.scheduler {
                ScheduleView(scheduler: scheduler, location: manager.location)
            } else {
                Text("Unavailable on this Mac")
                    .foregroundStyle(.secondary)
            }

            Divider()

            LoginItemToggle()

            SettingsButton()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q", modifiers: .command)
        } label: {
            MenuBarLabel(manager: manager)
        }

        Window("Nocturne Settings", id: SettingsButton.window) {
            SettingsView()
        }
        .windowResizability(.contentSize)
        .restorationBehavior(.disabled)
    }
}
