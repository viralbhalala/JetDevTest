//
//  String+Localized.swift
//  JetDevsHomeWork
//
//  Created by Developer on 24/12/22.
//

import Foundation

extension String {

    func localized() -> String {

        let currentLanguage = Language.english

        guard let path = Bundle.main.path(forResource: currentLanguage.rawValue, ofType: "lproj") else {
            return ""
        }

        guard let text = Bundle(path: path)?.localizedString(forKey: self, value: nil, table: nil) else {
            return ""
        }
        return text
    }

    func localizedFormat(_ arguments: CVarArg...) -> String {
        return String(format: localized(), arguments: arguments)
    }
}
public enum Language: String {
    case english = "en"
}

extension Language {

    public var locale: Locale {

        switch self {
        case .english:
            return Locale(identifier: "en_US")
        }
    }
}
