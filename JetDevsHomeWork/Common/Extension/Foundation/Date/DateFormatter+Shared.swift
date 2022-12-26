//
//  DateFormatter+Shared.swift
//  JetDevsHomeWork
//
//  Created by Developer on 26/12/22.
//

import Foundation

extension DateFormatter {

    static private var shared: DateFormatter?

    /**
    Returns shared `DateFormatter` instance.
    */
    public static func sharedInstance(
    ) -> DateFormatter {

        if let validFormatter = shared {
            return validFormatter
        }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_us")

        shared = formatter

        return formatter
    }

    public static func reset() {
        shared = nil
    }
}
