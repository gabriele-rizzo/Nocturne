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
                Picker("From", selection: start) { times(excluding: window.end) }
                Picker("To", selection: end) { times(excluding: window.start) }
            } label: {
                customTitle
            }
            
            if scheduler.needsLocation {
                Button("Enable Location…") { NSWorkspace.shared.open(.locationSettings) }
            }
        }

        Toggle("Prevent Dimming", isOn: $scheduler.preventsDimming)
    }

    private var window: DayWindow { scheduler.activation.window }

    private var customTitle: Text {
        let title = Text(ActivationMode.custom.title)

        guard scheduler.activation.mode == .custom else { return title }

        return Text(verbatim: "✓ ") + title
    }

    private func times(excluding conflict: DayTime) -> some View {
        ForEach(DayTime.steps.filter { $0 != conflict }, id: \.minutesSinceMidnight) { time in
            Text(label(time)).tag(time.minutesSinceMidnight)
        }
    }

    private func label(_ time: DayTime) -> String {
        var components = DateComponents()
        components.year = 2000
        components.month = 1
        components.day = 1
        components.hour = time.hour
        components.minute = time.minute

        guard let date = Calendar.current.date(from: components) else { return "" }

        return date.formatted(.dateTime.hour().minute())
    }

    private func selection(_ mode: ActivationMode) -> Binding<Bool> {
        Binding {
            scheduler.activation.mode == mode
        } set: { chosen in
            guard chosen else { return }

            select(mode)
        }
    }

    private var start: Binding<Int> {
        Binding {
            window.start.minutesSinceMidnight
        } set: { chosen in
            guard let time = DayTime(minutesSinceMidnight: chosen), time != window.end else { return }

            apply(DayWindow(start: time, end: window.end))
        }
    }

    private var end: Binding<Int> {
        Binding {
            window.end.minutesSinceMidnight
        } set: { chosen in
            guard let time = DayTime(minutesSinceMidnight: chosen), time != window.start else { return }

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
