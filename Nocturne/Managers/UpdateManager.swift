//
//  UpdateManager.swift
//  Nocturne
//
//  Created by Gabriele Rizzo on 09/08/26.
//

import Sparkle

@MainActor
final class UpdateManager {
    static let shared = UpdateManager()

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
}
