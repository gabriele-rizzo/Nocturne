//
//  LoginItemToggle.swift
//  Nocturne
//
//  Created by Gabriele Rizzo on 07/08/26.
//

import ServiceManagement
import SwiftUI

struct LoginItemToggle: View {
    var body: some View {
        Toggle("Launch at Login", isOn: launchesAtLogin)
    }

    private var launchesAtLogin: Binding<Bool> {
        Binding {
            SMAppService.launchesAtLogin
        } set: {
            SMAppService.launchesAtLogin = $0
        }
    }
}
