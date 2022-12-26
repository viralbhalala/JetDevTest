//
//  UserDefaultRepository.swift
//  JetDevsHomeWork
//
//  Created by Developer on 24/12/22.
//

import Foundation
import RxSwift
import RxCocoa

final class UserDefaultRepository: UserRepository {

    // Singleton instance to make sure all part of app use and observe the same `userSetting`
    static let shared = UserDefaultRepository()

    // MARK: - Private Properties
    private let userSetting = BehaviorRelay<UserSetting?>(value: nil)
    private let disposeBag = DisposeBag()
    private let userSettingLocalDataSource: UserSettingLocalDataSource

    // MARK: - Initialization

    init(
        userSettingLocalDataSource: UserSettingLocalDataSource = UserSettingDefaultLocalDataSource()
    ) {

        self.userSettingLocalDataSource = userSettingLocalDataSource

        configureInitialUserSetting()
    }
    
    // MARK: - Public Methods

    func setUserId(_ userId: Int?) {

        userSettingLocalDataSource.setUserId(userId)

        var newSetting = userSetting.value
        newSetting?.userId = userId

        userSetting.accept(newSetting)
    }
    
    func getUserId() -> Int? {
        userSettingLocalDataSource.getUserId()
    }
    
    func setUser(_ user: UserResponse) {
        userSettingLocalDataSource.setUser(user)
        setUserId(user.data?.user?.userId)
    }

    func getUser() -> UserResponse? {
        userSettingLocalDataSource.getUser()
    }
    
    func observeUserSetting() -> Observable<UserSetting> {
        userSetting.asObservable().filterNil()
    }
    
    // MARK: - Private Methods

    func configureInitialUserSetting() {

        let setting = UserSetting(
            userId: userSettingLocalDataSource.getUserId()
        )

        userSetting.accept(setting)
    }

}
