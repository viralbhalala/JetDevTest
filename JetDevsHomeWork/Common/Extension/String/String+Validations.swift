//
//  String+Validations.swift
//  JetDevsHomeWork
//
//  Created by Developer on 24/12/22.
//

import Foundation

extension String {

    var isValidEmailAddress: Bool {
        if self.count >= 5 && self.count <= 128,
           let atIndex = self.firstIndex(of: "@")?.utf16Offset(in: self),
           let dotIndex = self.lastIndex(of: ".")?.utf16Offset(in: self),
           atIndex > 0 &&
           dotIndex > 2 &&
           atIndex < dotIndex {
            return true
        }
        return false
    }

    var isPasswordPassedMinLength: Bool {
        return self.count >= 8
    }

    var isValidPassword: Bool {
        return self.count >= 8 && self.count <= 40
    }

}
