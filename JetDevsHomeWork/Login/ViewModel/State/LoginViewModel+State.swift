//
//  LoginViewModel+State.swift
//  JetDevsHomeWork
//
//  Created by Developer on 24/12/22.
//

import Foundation

extension LoginViewModel {

    enum State: ViewModelState {
        case showLoading(Bool)
        case showError(title: String, message: NSAttributedString, shouldResetEmail: Bool = false)
        case dissmissScreen
        case enableLoginButton(Bool)
        case showEmailError(String)
        case showPasswordError(String)
    }
}
