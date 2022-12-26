//
//  LoginViewController.swift
//  JetDevsHomeWork
//
//  Created by Developer on 24/12/22.
//

import UIKit
import RxSwift
import IQKeyboardManagerSwift

class LoginViewController: BaseViewController {

    typealias ViewModel = AnyViewModel<LoginViewModel.State, LoginViewModel.Event>

    // MARK: - Private Properties

    @IBOutlet private weak var emailTextField: TextField!
    @IBOutlet private weak var passwordTextField: TextField!
    @IBOutlet private weak var loginButton: UIButton!

    private let viewModel: ViewModel

    // MARK: - Initialization

    init(viewModel: ViewModel = AnyViewModel(LoginViewModel())) {
        self.viewModel = viewModel
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true

        configureElementLocalization()
        configureEmailTextField()
        configurePasswordTextField()
        configureLoginButton()
        configureFonts()

        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: true)

        IQKeyboardManager.shared.enable = true
    }
    
    // MARK: - Private Methods

    private func configureElementLocalization() {

        emailTextField.setPlaceholder("email".localized())
        passwordTextField.setPlaceholder("password".localized())

        loginButton.setTitle("login".localized(), for: .normal)

    }

    private func configureFonts() {
        
        loginButton.titleLabel?.font = UIFont.latoSemiBoldFont(size: 16)
    }
    
    private func defaultClose() {
        dismiss(animated: true)
    }

    private func bindViewModel() {

        viewModel.state
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in

                switch state {
                case .enableLoginButton(let isEnabled):
                    self?.loginButton.isEnabled = isEnabled
                    self?.loginButton.apply(style: isEnabled ? .primary() : .disabled())

                case .showEmailError(let error):
                    self?.emailTextField.setError(error)

                case .showPasswordError(let error):
                    self?.passwordTextField.setError(error)

                case .dissmissScreen:
                    self?.defaultClose()

                case .showLoading(let show):
                    self?.showLoading(show)

                case .showError(let title, let message, let resetEmail):
                    self?.showErrorAlert(title: title, message: message, shouldResetEmail: resetEmail)
                }
            })
            .disposed(by: disposeBag)

        viewModel.onReceiveEvent(.viewLoaded)

    }

    private func configureEmailTextField() {

        emailTextField.setTitle("email".localized())
        emailTextField.setMaximumLength(128)
        emailTextField.setAutoCompletedEmail()

        emailTextField.valueChanged
            .withUnretained(self)
            .subscribe(onNext: { (viewController, text) in
                viewController.viewModel.onReceiveEvent(.emailTextChanged(text.orEmpty))
            })
            .disposed(by: disposeBag)

        emailTextField.isFocusedObservable
            .skip(1)
            .withUnretained(self)
            .subscribe(onNext: { (viewController, isFocused: Bool) in
                if !isFocused {
                    viewController.viewModel.onReceiveEvent(.emailTextEndEditing)
                }
            })
            .disposed(by: disposeBag)

    }

    private func configurePasswordTextField() {

        passwordTextField.setTitle("password".localized())
        passwordTextField.setMaximumLength(255)
        passwordTextField.setAsSecureTextEntry(true)
      
        passwordTextField.valueChanged
            .withUnretained(self)
            .subscribe(onNext: { (viewController, text: String?) in
                viewController.viewModel.onReceiveEvent(.passwordTextChanged(text.orEmpty))
            })
            .disposed(by: disposeBag)

        passwordTextField.isFocusedObservable
            .skip(1)
            .withUnretained(self)
            .subscribe(onNext: { (viewController, isFocused: Bool) in
                if !isFocused {
                    viewController.viewModel.onReceiveEvent(.passwordTextEndEditing)
                }
            })
            .disposed(by: disposeBag)
    }

    private func configureLoginButton() {
        loginButton.apply(style: .disabled())
    }

    private func showLoading(_ show: Bool) {

        if show {
            JetdevProgress.show()
        } else {
            JetdevProgress.dismiss()
        }
    }

    private func showErrorAlert(
        title: String,
        message: NSAttributedString,
        shouldResetEmail: Bool,
        actionTitle: String = "close".localized(),
        onActionTapped: (() -> Void)? = nil
    ) {

        let configuration = AlertViewController.Configuration(
            title: title,
            attributedMessage: message,
            positiveAction: .init(title: actionTitle) { [weak self] in

                if shouldResetEmail {
                    self?.emailTextField.setValue(nil)
                }

                self?.passwordTextField.setValue(nil)

                if let action = onActionTapped {
                    action()
                } else {
                    self?.passwordTextField.becomeFirstResponder()
                }
            }
        )

        AlertViewController(configuration: configuration).show(in: self)
    }

    // MARK: - IBAction

    @IBAction private func onLoginButtonTapped(_ sender: UIButton) {
        view.endEditing(true)
        viewModel.onReceiveEvent(.loginButtonTapped)
    }

    @IBAction private func onCloseButtonTapped(_ sender: UIButton) {
        view.endEditing(true)
        viewModel.onReceiveEvent(.closeButtonTapped)
    }
}

extension LoginViewController {

    static func show(
      in viewController: UIViewController,
      animated: Bool = true,
      completion: (() -> Void)? = nil
    ) {

        let loginViewNavigationController = RotationRestrictedNavigationController(rootViewController: LoginViewController())
        loginViewNavigationController.modalPresentationStyle = .overFullScreen
        viewController.present(loginViewNavigationController, animated: true, completion: nil)
    }
}
