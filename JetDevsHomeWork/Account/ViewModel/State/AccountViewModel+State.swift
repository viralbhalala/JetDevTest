//
//  AccountViewModel+State.swift
//  JetDevsHomeWork
//
//  Created by Developer on 24/12/22.
//

import Foundation

extension AccountViewModel {

    enum State: ViewModelState {
        case showLoginScreen
        case showProfileDetail(UserResponse)
    }
}
