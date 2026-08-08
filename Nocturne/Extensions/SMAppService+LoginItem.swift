//
//  SMAppService+LoginItem.swift
//  Nocturne
//
//  Created by Gabriele Rizzo on 07/08/26.
//

import ServiceManagement

extension SMAppService {
    static var launchesAtLogin: Bool {
        get { mainApp.status == .enabled }
        set {
            if newValue {
                try? mainApp.register()
            } else {
                try? mainApp.unregister()
            }
        }
    }

    static var needsApproval: Bool { mainApp.status == .requiresApproval }
}
