//
//  KeyboardBacklightController.swift
//  Nocturne
//
//  Created by Gabriele Rizzo on 07/08/26.
//

import Foundation

@objc protocol KeyboardBacklightClient {
    @objc(brightnessForKeyboard:)
    func brightness(forKeyboard id: UInt64) -> Float

    @objc(setBrightness:fadeSpeed:commit:forKeyboard:)
    func setBrightness(_ brightness: Float, fadeSpeed: Int32, commit: Bool, forKeyboard id: UInt64) -> Bool

    @objc(copyKeyboardBacklightIDs)
    func copyKeyboardBacklightIDs() -> NSArray?

    @objc(isKeyboardBuiltIn:)
    func isKeyboardBuiltIn(_ id: UInt64) -> Bool

    @objc(idleDimTimeForKeyboard:)
    func idleDimTime(forKeyboard id: UInt64) -> Double

    @objc(setIdleDimTime:forKeyboard:)
    func setIdleDimTime(_ seconds: Double, forKeyboard id: UInt64) -> Bool
}

final class KeyboardBacklightController {
    private let client: KeyboardBacklightClient
    private let keyboardID: UInt64

    init?() {
        let bundle = Bundle(path: "/System/Library/PrivateFrameworks/CoreBrightness.framework")

        guard bundle?.load() == true,
              let cls = NSClassFromString("KeyboardBrightnessClient") as? NSObject.Type
        else { return nil }

        let instance = cls.init()
        let client = unsafeBitCast(instance, to: KeyboardBacklightClient.self)
        let ids = (client.copyKeyboardBacklightIDs() as? [NSNumber])?.map(\.uint64Value) ?? []

        guard let id = ids.first(where: { client.isKeyboardBuiltIn($0) }) ?? ids.first else { return nil }

        self.client = client
        self.keyboardID = id
    }

    func get() -> Double? {
        let value = client.brightness(forKeyboard: keyboardID)
        
        guard value >= 0 else { return nil }
        return Double(value)
    }

    @discardableResult
    func set(_ value: Double, fadeMilliseconds: Int32 = 500) -> Double? {
        let clamped = Float(min(max(value, 0), 1))
        let ok = client.setBrightness(clamped, fadeSpeed: fadeMilliseconds, commit: true, forKeyboard: keyboardID)
        
        return ok ? Double(clamped) : nil
    }

    var idleDimTime: Double {
        get { client.idleDimTime(forKeyboard: keyboardID) }
        set { _ = client.setIdleDimTime(newValue, forKeyboard: keyboardID) }
    }
}
