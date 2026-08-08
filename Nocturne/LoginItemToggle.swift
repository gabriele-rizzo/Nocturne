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

    var body: some View {
        Toggle("Launch at Login", isOn: launchesAtLogin)
    }

    private var launchesAtLogin: Binding<Bool> {
        Binding {
            enabled
        } set: { requested in
            SMAppService.launchesAtLogin = requested
            enabled = SMAppService.launchesAtLogin
        }
    }
}
