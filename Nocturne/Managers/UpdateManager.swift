//
//  UpdateManager.swift
//  Nocturne
//
//  Created by Gabriele Rizzo on 09/08/26.
//

import AppKit
import Sparkle

@MainActor
final class UpdateManager {
    static let shared = UpdateManager()

    private static let launchesKey = "updateLaunches"
    private static let askedKey = "updateAsked"
    private static let sparkleKey = "SUEnableAutomaticChecks"

    private let controller: SPUStandardUpdaterController?

    var available: Bool { controller != nil }

    private init() {
        let key = Bundle.main.object(forInfoDictionaryKey: "SUPublicEDKey") as? String

        guard let key, !key.isEmpty else {
            controller = nil

            return
        }

        controller = SPUStandardUpdaterController(
            startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil
        )

        let defaults = UserDefaults.standard
        defaults.set(defaults.integer(forKey: Self.launchesKey) + 1, forKey: Self.launchesKey)

        if defaults.object(forKey: Self.sparkleKey) != nil {
            defaults.set(true, forKey: Self.askedKey)
        }

        guard defaults.integer(forKey: Self.launchesKey) > 1,
              !defaults.bool(forKey: Self.askedKey)
        else { return }

        Task { ask() }
    }

    var checksAutomatically: Bool {
        get { controller?.updater.automaticallyChecksForUpdates ?? false }
        set { controller?.updater.automaticallyChecksForUpdates = newValue }
    }

    var downloadsAutomatically: Bool {
        get { controller?.updater.automaticallyDownloadsUpdates ?? false }
        set { controller?.updater.automaticallyDownloadsUpdates = newValue }
    }

    func check() {
        controller?.checkForUpdates(nil)
    }

    private func ask() {
        let alert = NSAlert()
        alert.messageText = String(localized: "Check for updates automatically?")
        alert.informativeText = String(
            localized: "Nocturne can look for new versions on its own. You can check yourself, and change this, from Settings in the menu."
        )
        alert.addButton(withTitle: String(localized: "Check automatically"))
        alert.addButton(withTitle: String(localized: "Don't Check"))

        NSApplication.shared.activate()

        let automatic = alert.runModal() == .alertFirstButtonReturn

        UserDefaults.standard.set(true, forKey: Self.askedKey)
        checksAutomatically = automatic
    }
}
