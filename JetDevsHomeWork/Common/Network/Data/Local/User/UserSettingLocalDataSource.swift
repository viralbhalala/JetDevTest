//
//  UserSettingLocalDataSource.swift
//  JetDevsHomeWork
//
//  Created by Developer on 24/12/22.
//

import Foundation
import RxSwift

protocol UserSettingLocalDataSource {

    func setUserId(_ userId: Int?)

    func getUserId() -> Int?

    func setUser(_ user: UserResponse)
    
    func getUser() -> UserResponse?

}
