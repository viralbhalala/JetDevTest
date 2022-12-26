//
//  AuthDefaultRepository.swift
//  JetDevsHomeWork
//
//  Created by Developer on 24/12/22.
//

import Foundation
import RxSwift
import Moya

final class AuthDefaultRepository: AuthRepository {

    private let remoteDataSource: AuthRemoteDataSource

    init(
        remoteDataSource: AuthRemoteDataSource = AuthDefaultRemoteDataSource()
    ) {
        self.remoteDataSource = remoteDataSource
    }

    func login(with parameter: UserCredentialRequest) -> Single<UserResponse> {
        remoteDataSource.login(with: parameter)
    }
}
