//
//  AccountViewModel+Event.swift
//  JetDevsHomeWork
//
//  Created by Developer on 24/12/22.
//

import Foundation

extension AccountViewModel {

    enum Event: ViewModelEvent {
        case viewLoaded
        case viewWillAppear
        case loginButtonTapped
    }
}
