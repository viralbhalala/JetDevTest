//
//  Date+String.swift
//  JetDevsHomeWork
//
//  Created by Developer on 26/12/22.
//

import Foundation

extension Date {

    public func toString(
        format: DateFormat,
        formatter: DateFormatter = DateFormatter.sharedInstance()
    ) -> String {

        formatter.dateFormat = format.rawValue

        return formatter.string(from: self)
    }
    
    func timeAgoDisplay() -> String {
         let formatter = RelativeDateTimeFormatter()
         formatter.unitsStyle = .full
         return formatter.localizedString(for: self, relativeTo: Date())
     }
}

extension String {

    public func toDate(
        format: DateFormat,
        formatter: DateFormatter = DateFormatter.sharedInstance()
    ) -> Date? {

        formatter.dateFormat = format.rawValue

        return formatter.date(from: self)
    }
}

public enum DateFormat: String {
    case utc = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
}
