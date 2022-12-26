//
//  UserSettingDefaultLocalDataSource.swift
//  JetDevsHomeWork
//
//  Created by Developer on 24/12/22.
//

import Foundation
import RxSwift
import KeychainSwift

final class UserSettingDefaultLocalDataSource: UserSettingLocalDataSource {

    // MARK: - Private Properties
    private let userData = "UserData"

    private let userDefaults: UserDefaults
    private let keychain: Keychain

    // MARK: - Initialization

    init(userDefaults: UserDefaults = .standard, keychain: Keychain = KeychainSwift()) {

        self.userDefaults = userDefaults
        self.keychain = keychain
    }

    // MARK: - Public Methods

    func setUserId(_ userId: Int?) {
        if let userId = userId {
            userDefaults.setValue(String(userId), forKey: KeychainKey.userID.rawValue)
        }
    }

    func getUserId() -> Int? {
        
        guard let userId = userDefaults.string(forKey: KeychainKey.userID.rawValue) else {
            return nil
        }
        return Int(userId)
    }
    
    func setUser(_ user: UserResponse) {
        guard let user = user.toJSONString() else {
            return
        }
        userDefaults.setValue(user, forKey: KeychainKey.userData.rawValue)
    }

    func getUser() -> UserResponse? {
        guard let rawData = userDefaults.string(forKey: KeychainKey.userData.rawValue) else {
            return nil
        }
        let data = Data(rawData.utf8)
        let user = try? JSONDecoder().decode(UserResponse.self, from: data)
        return (user ?? nil)
    }

    func clear() {
        keychain.delete(key: .userID)
    }

}
