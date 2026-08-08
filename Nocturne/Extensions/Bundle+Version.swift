//
//  Bundle+Version.swift
//  Nocturne
//
//  Created by Gabriele Rizzo on 09/08/26.
//

import Foundation

extension Bundle {
    var version: String {
        infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

    var build: String {
        infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
}
