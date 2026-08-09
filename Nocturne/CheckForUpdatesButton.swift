//
//  CheckForUpdatesButton.swift
//  Nocturne
//
//  Created by Gabriele Rizzo on 09/08/26.
//

import SwiftUI

struct CheckForUpdatesButton: View {
    var body: some View {
        if UpdateManager.shared.available {
            Button("Check for Updates…") { UpdateManager.shared.check() }
        }
    }
}
