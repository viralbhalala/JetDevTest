//
//  AccountViewModel.swift
//  JetDevsHomeWork
//
//  Created by Developer on 24/12/22.
//

import Foundation
import RxSwift
import RxCocoa

final class AccountViewModel {

    // MARK: - Private Properties

    private let mutableState = BehaviorRelay<State?>(value: nil)
    private let userRepository: UserRepository

    private let disposeBag = DisposeBag()

    // MARK: - Initialization

    init(userRepository: UserRepository = UserDefaultRepository.shared) {
        self.userRepository = userRepository
        
        observeUserLogin()
    }

    // MARK: - Private Methods

    private func onViewLoaded() {
        checkUserIsLogin()
    }
    
    private func onViewWillAppear() {
        checkUserIsLogin()
    }
    
    private func checkUserIsLogin() {
        if let userId = userRepository.getUserId(), userId > 0, let user = userRepository.getUser() {
            mutableState.accept(.showProfileDetail(user))
        }
    }
    
    private func observeUserLogin() {
        userRepository.observeUserSetting()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.checkUserIsLogin()
            })
            .disposed(by: disposeBag)
    }
}

extension AccountViewModel: ViewModel {

    var state: Observable<State> {

        mutableState.asObservable().filterNil()
    }

    func onReceiveEvent(_ event: Event) {

        switch event {
        case .viewLoaded:
            onViewLoaded()

        case .viewWillAppear:
            onViewWillAppear()
            
        case .loginButtonTapped:
            mutableState.accept(.showLoginScreen)
        }
    }
}
