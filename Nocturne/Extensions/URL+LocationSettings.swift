//
//  URL+LocationSettings.swift
//  Nocturne
//
//  Created by Gabriele Rizzo on 07/08/26.
//

import Foundation

extension URL {
    static let locationSettings = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_LocationServices")!
}
