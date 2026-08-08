//
//  UpdatesSection.swift
//  Nocturne
//
//  Created by Gabriele Rizzo on 09/08/26.
//

import SwiftUI

struct UpdatesSection: View {
    @State private var checks = UpdateManager.shared.checksAutomatically
    @State private var downloads = UpdateManager.shared.downloadsAutomatically

    var body: some View {
        if UpdateManager.shared.available {
            updates
        }
    }

    private var updates: some View {
        VStack(spacing: 8) {
            Divider()

            Button("Check for Updates…") { UpdateManager.shared.check() }

            VStack(alignment: .leading, spacing: 4) {
                Toggle("Check automatically", isOn: checksAutomatically)

                Toggle("Download automatically", isOn: downloadsAutomatically)
                    .disabled(!checks)
            }
            .toggleStyle(.checkbox)
            .font(.callout)
        }
    }

    private var checksAutomatically: Binding<Bool> {
        Binding {
            checks
        } set: { requested in
            UpdateManager.shared.checksAutomatically = requested
            checks = UpdateManager.shared.checksAutomatically
        }
    }

    private var downloadsAutomatically: Binding<Bool> {
        Binding {
            downloads
        } set: { requested in
            UpdateManager.shared.downloadsAutomatically = requested
            downloads = UpdateManager.shared.downloadsAutomatically
        }
    }
}
