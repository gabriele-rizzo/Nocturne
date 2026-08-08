//
//  ScheduleView.swift
//  Nocturne
//
//  Created by Gabriele Rizzo on 07/08/26.
//

import SwiftUI

struct ScheduleView: View {
    @Bindable var scheduler: BacklightScheduleManager
    let location: LocationManager

    var body: some View {
        Section("Schedule") {
            ForEach([ActivationMode.on, .off, .solar], id: \.self) { mode in
                Toggle(mode.title, isOn: selection(mode))
            }
            
            Menu {
                Picker("From", selection: startHour) { hours(excluding: window.end.hour) }
                Picker("To", selection: endHour) { hours(excluding: window.start.hour) }
            } label: {
                Text(customTitle)
            }
            
            if scheduler.needsLocation {
                Button("Enable Location…") { NSWorkspace.shared.open(.locationSettings) }
            }
        }
    }

    private var window: DayWindow { scheduler.activation.window }

    private var customTitle: String {
        let title = ActivationMode.custom.title

        guard scheduler.activation.mode == .custom else { return title }

        return "✓ \(title)"
    }

    private func hours(excluding conflict: Int) -> some View {
        ForEach((0..<24).filter { $0 != conflict }, id: \.self) { hour in
            Text(String(format: "%02d:00", hour)).tag(hour)
        }
    }

    private func selection(_ mode: ActivationMode) -> Binding<Bool> {
        Binding {
            scheduler.activation.mode == mode
        } set: { chosen in
            guard chosen else { return }

            select(mode)
        }
    }

    private var startHour: Binding<Int> {
        Binding {
            window.start.hour
        } set: { chosen in
            guard let time = DayTime(hour: chosen, minute: 0), time != window.end else { return }

            apply(DayWindow(start: time, end: window.end))
        }
    }

    private var endHour: Binding<Int> {
        Binding {
            window.end.hour
        } set: { chosen in
            guard let time = DayTime(hour: chosen, minute: 0), time != window.start else { return }

            apply(DayWindow(start: window.start, end: time))
        }
    }

    private func apply(_ window: DayWindow) {
        var updated = scheduler.activation
        updated.window = window
        updated.mode = .custom
        scheduler.activation = updated
    }

    private func select(_ mode: ActivationMode) {
        if mode == .solar {
            location.request()
        }

        scheduler.activation.mode = mode
    }
}
