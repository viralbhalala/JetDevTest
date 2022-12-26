//
//  UserRepository.swift
//  JetDevsHomeWork
//
//  Created by Developer on 24/12/22.
//

import Foundation
import RxSwift

public protocol UserRepository {
    
    func observeUserSetting() -> Observable<UserSetting>

    func setUserId(_ userId: Int?)
    
    func getUserId() -> Int?

    func setUser(_ user: UserResponse)
    
    func getUser() -> UserResponse?
}

public struct UserSetting: Equatable {

    public var userId: Int?
}
