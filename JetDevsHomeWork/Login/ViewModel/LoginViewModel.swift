//
//  LoginViewModel.swift
//  JetDevsHomeWork
//
//  Created by Developer on 24/12/22.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyAttributes

final class LoginViewModel {
    
    typealias LogIn = AnyUseCase<UserResponse, UserCredentialRequest>

    // MARK: - Private Properties

    private let mutableState = BehaviorRelay<State?>(value: nil)
    private let isSaveEmail: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private let email: BehaviorRelay<String> = BehaviorRelay(value: "")
    private let password: BehaviorRelay<String> = BehaviorRelay(value: "")
    private let disposeBag = DisposeBag()
    private let logIn: LogIn
    private let userRepository: UserRepository

    // MARK: - Initialization

    init(
        logIn: LogIn = AnyUseCase(LogInUseCase.make()),
        userRepository: UserRepository = UserDefaultRepository.shared
    ) {

        self.logIn = logIn
        self.userRepository = userRepository

        bindForLoginButtonState()
    }

    // MARK: - Private Methods

    private func onViewLoaded() {

    }
    
    private func bindForLoginButtonState() {

        Observable.combineLatest(email.asObservable(), password.asObservable())
            .map { (email, password) in
                email.isValidEmailAddress && password.isPasswordPassedMinLength
            }
            .map { (enabled) in
                State.enableLoginButton(enabled)
            }
            .bind(to: mutableState)
            .disposed(by: disposeBag)
    }

    @discardableResult
    private func validateEmail() -> Bool {

        if email.value.isValidEmailAddress {
            return true
        }

        mutableState.accept(.showEmailError("invalid_email_format".localized()))

        return false
    }

    @discardableResult
    private func validatePasswordMinLength() -> Bool {

        if password.value.isPasswordPassedMinLength {
            return true
        }

        mutableState.accept(.showPasswordError("password_minimum_length".localized()))

        return false
    }

    private func onEmailTextEndEditing() {
        if !email.value.isEmpty {
            validateEmail()
        }
    }
    
    private func onPasswordTextEndEditing() {
        if !password.value.isEmpty {
            validatePasswordMinLength()
        }
    }
    
    private func onLoginError(_ error: Error) {

        let errorState: State

        switch error as? JetdevAPIError {
      
        case .systemError(let message):
            errorState = .showError(
                title: "login_failed".localized(),
                message: (message ?? "unable_to_login".localized()).withFont(.latoRegularFont(size: 14))
            )

        default:
            errorState = .showError(
                title: "oops".localized(),
                message: "something_went_wrong".localized().withFont(.latoRegularFont(size: 14))
            )
        }

        mutableState.accept(.showLoading(false))
        mutableState.accept(errorState)
    }

    private func onLoginButtonTapped() {

        guard validateEmail() && validatePasswordMinLength() else {
            return
        }

        mutableState.accept(.showLoading(true))

        let parameter = UserCredentialRequest(email: email.value, password: password.value)

        logIn.execute(with: parameter)
            .withUnretained(self)
            .subscribe(onSuccess: { (viewModel, userModel) in
                viewModel.mutableState.accept(.showLoading(false))
                viewModel.userRepository.setUser(userModel)
                viewModel.mutableState.accept(.dissmissScreen)
            }, onFailure: { [weak self] error in
                self?.onLoginError(error)
            })
            .disposed(by: disposeBag)
    }

}

extension LoginViewModel: ViewModel {

    var state: Observable<State> {
        mutableState.asObservable().filterNil()
    }

    func onReceiveEvent(_ event: Event) {

        switch event {
        case .viewLoaded:
            onViewLoaded()

        case .emailTextChanged(let email):
            self.email.accept(email)

        case .passwordTextChanged(let password):
            self.password.accept(password)

        case .emailTextEndEditing:
            onEmailTextEndEditing()

        case .passwordTextEndEditing:
            onPasswordTextEndEditing()

        case .loginButtonTapped:
            onLoginButtonTapped()

        case .closeButtonTapped:
            mutableState.accept(.dissmissScreen)
        }
    }
}
