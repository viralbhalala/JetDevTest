//
//  LoginViewModel+Event.swift
//  JetDevsHomeWork
//
//  Created by Developer on 24/12/22.
//

import Foundation

extension LoginViewModel {

    enum Event: ViewModelEvent {
        case viewLoaded
        case emailTextChanged(String)
        case emailTextEndEditing
        case passwordTextChanged(String)
        case passwordTextEndEditing
        case loginButtonTapped
        case closeButtonTapped
    }
}
