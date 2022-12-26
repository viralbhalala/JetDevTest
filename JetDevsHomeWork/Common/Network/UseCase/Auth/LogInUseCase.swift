//
//  LogInUseCase.swift
//  JetDevsHomeWork
//
//  Created by Developer on 24/12/22.
//

import Foundation
import RxSwift
import Moya

public struct LogInUseCase: UseCase {

    typealias PrepareUserPreferences = AnyUseCase<Void, Void>

    // MARK: - Private Properties

    private let authRepository: AuthRepository
    private let disposeBag = DisposeBag()

    // MARK: - Initialization

    init(
        authRepository: AuthRepository = AuthDefaultRepository()
    ) {
        self.authRepository = authRepository
    }

    // MARK: - Public Methods

    public static func make() -> LogInUseCase {
        LogInUseCase()
    }

    public func execute(with parameters: UserCredentialRequest) -> Single<UserResponse> {
        return authRepository.login(with: parameters)
    }
}
