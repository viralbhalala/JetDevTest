//
//  Optional+EmptyString.swift
//  JetDevsHomeWork
//
//  Created by Developer on 24/12/22.
//

import Foundation

extension Optional where Wrapped == String {

    public var orEmpty: String {
        (self ?? "")
    }

    public func ifNilOrEmpty(replaceWith replacement: String) -> String {
        if let valid = self, !valid.isEmpty {
            return valid
        }
        return replacement
    }
}
