//
//  Suppression+Solar.swift
//  Nocturne
//
//  Created by Gabriele Rizzo on 07/08/26.
//

import Foundation

private let radians = Double.pi / 180

private func solarPosition(_ julianDay: Double) -> (declination: Double, equationOfTime: Double) {
    let century = (julianDay - 2451545) / 36525

    let meanLongitude = (280.46646 + century * (36000.76983 + century * 0.0003032))
        .truncatingRemainder(dividingBy: 360)
    let meanAnomaly = 357.52911 + century * (35999.05029 - 0.0001537 * century)
    let eccentricity = 0.016708634 - century * (0.000042037 + 0.0000001267 * century)

    let center = sin(meanAnomaly * radians) * (1.914602 - century * (0.004817 + 0.000014 * century))
        + sin(2 * meanAnomaly * radians) * (0.019993 - 0.000101 * century)
        + sin(3 * meanAnomaly * radians) * 0.000289

    let moonAscending = (125.04 - 1934.136 * century) * radians
    let apparentLongitude = meanLongitude + center - 0.00569 - 0.00478 * sin(moonAscending)

    let meanObliquity = 23 + (26 + (21.448 - century * (46.815 + century * (0.00059 - century * 0.001813))) / 60) / 60
    let obliquity = (meanObliquity + 0.00256 * cos(moonAscending)) * radians

    let y = pow(tan(obliquity / 2), 2)
    let equationOfTime = 4 * (y * sin(2 * meanLongitude * radians)
        - 2 * eccentricity * sin(meanAnomaly * radians)
        + 4 * eccentricity * y * sin(meanAnomaly * radians) * cos(2 * meanLongitude * radians)
        - 0.5 * y * y * sin(4 * meanLongitude * radians)
        - 1.25 * eccentricity * eccentricity * sin(2 * meanAnomaly * radians)) / radians

    return (asin(sin(obliquity) * sin(apparentLongitude * radians)), equationOfTime)
}

extension Suppression {
    static func solar(
        on date: Date,
        at coordinate: Coordinate,
        zenith: SolarZenith = .civilTwilight,
        calendar: Calendar = .current
    ) -> Suppression {
        var utc = Calendar(identifier: .gregorian)
        utc.timeZone = TimeZone(secondsFromGMT: 0)!

        guard let noon = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: date) else { return .never }

        let midnight = utc.startOfDay(for: noon)
        let julianDay = midnight.timeIntervalSince1970 / 86400 + 2440587.5
        let latitude = coordinate.latitude * radians
        let target = cos(zenith.degrees * radians)

        func cosHourAngle(_ declination: Double) -> Double {
            (target - sin(latitude) * sin(declination)) / (cos(latitude) * cos(declination))
        }

        let midday = cosHourAngle(solarPosition(julianDay + 0.5).declination)

        guard midday <= 1 else { return .never }
        guard midday >= -1 else { return .always }

        func event(rising: Bool) -> Double {
            var minutes = 720.0

            for _ in 0..<2 {
                let position = solarPosition(julianDay + minutes / 1440)
                let cosine = cosHourAngle(position.declination)

                guard abs(cosine) <= 1 else { return minutes }

                let hourAngle = acos(cosine) / radians
                let solarNoon = 720 - 4 * coordinate.longitude - position.equationOfTime

                minutes = rising ? solarNoon - 4 * hourAngle : solarNoon + 4 * hourAngle
            }

            return minutes
        }

        guard let start = DayTime(midnight.addingTimeInterval(event(rising: true).rounded() * 60), calendar: calendar),
              let end = DayTime(midnight.addingTimeInterval(event(rising: false).rounded() * 60), calendar: calendar)
        else { return .never }

        return .during(DayWindow(start: start, end: end))
    }
}
