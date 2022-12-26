//
//  Keychain.swift
//  JetDevsHomeWork
//
//  Created by Developer on 24/12/22.
//

import Foundation
import KeychainSwift

protocol Keychain {
    
    func setValue(_ value: String, forKey key: KeychainKey)

    func setValue(_ value: Bool, forKey key: KeychainKey)

    func setValue(_ value: Data, forKey key: KeychainKey)

    func string(forKey key: KeychainKey) -> String?

    func bool(forKey key: KeychainKey) -> Bool?

    func data(forKey key: KeychainKey) -> Data?

    func delete(key: KeychainKey)

    func deleteAll()
}

extension KeychainSwift: Keychain {
    
    func setValue(_ value: String, forKey key: KeychainKey) {
        set(value, forKey: key.rawValue)
    }

    func setValue(_ value: Bool, forKey key: KeychainKey) {
        set(value, forKey: key.rawValue)
    }

    func setValue(_ value: Data, forKey key: KeychainKey) {
        set(value, forKey: key.rawValue)
    }

    func string(forKey key: KeychainKey) -> String? {
        get(key.rawValue)
    }

    func bool(forKey key: KeychainKey) -> Bool? {
        getBool(key.rawValue)
    }

    func data(forKey key: KeychainKey) -> Data? {
        getData(key.rawValue)
    }

    func delete(key: KeychainKey) {
        delete(key.rawValue)
    }

    func deleteAll() {
        clear()
    }
}
