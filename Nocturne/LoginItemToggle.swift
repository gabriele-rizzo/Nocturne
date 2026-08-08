//
//  LoginItemToggle.swift
//  Nocturne
//
//  Created by Gabriele Rizzo on 07/08/26.
//

import ServiceManagement
import SwiftUI

struct LoginItemToggle: View {
    @State private var enabled = SMAppService.launchesAtLogin
    @State private var needsApproval = SMAppService.needsApproval

    var body: some View {
        Group {
            Toggle("Launch at Login", isOn: launchesAtLogin)

            if needsApproval {
                Button("Approve in Login Items…") { NSWorkspace.shared.open(.loginItemsSettings) }
            }
        }
    }

    private var launchesAtLogin: Binding<Bool> {
        Binding {
            enabled
        } set: { requested in
            SMAppService.launchesAtLogin = requested
            enabled = SMAppService.launchesAtLogin
            needsApproval = SMAppService.needsApproval
        }
    }
}
