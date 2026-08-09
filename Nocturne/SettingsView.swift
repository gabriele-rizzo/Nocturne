//
//  SettingsView.swift
//  Nocturne
//
//  Created by Gabriele Rizzo on 09/08/26.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 12) {
                Image(nsImage: NSApplication.shared.applicationIconImage)
                    .resizable()
                    .frame(width: 96, height: 96)

                VStack(spacing: 4) {
                    Text(verbatim: "Nocturne")
                        .font(.title2.weight(.semibold))

                    Text("Your keyboard backlight, on a schedule.")
                        .font(.callout)
                        .foregroundStyle(.secondary)

                    Text(versionLabel)
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }

                Link("View on GitHub", destination: .repository)
            }

            UpdatesSection()

            Text("Released under the PolyForm Noncommercial License 1.0.0.")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .multilineTextAlignment(.center)
        .padding(24)
        .frame(width: 320)
    }

    private var versionLabel: String {
        let bundle = Bundle.main

        return String(localized: "Version \(bundle.version) (\(bundle.build))")
    }
}
