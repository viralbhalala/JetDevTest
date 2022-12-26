//
//  AuthDefaultRemoteDataSource.swift
//  JetDevsHomeWork
//
//  Created by Developer on 24/12/22.
//

import Foundation
import RxSwift
import Moya

final class AuthDefaultRemoteDataSource: AuthRemoteDataSource {

    private let provider: MoyaProvider<AuthTargetType>
    private let decoder: JSONDecoder

    init(provider: MoyaProvider<AuthTargetType> = .defaultProvider()) {
        self.provider = provider
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601
    }

    func login(with parameter: UserCredentialRequest) -> Single<UserResponse> {
        provider
            .requestWithValidation(.login(parameter: parameter))
            .map(to: UserResponse.self, decoder: self.decoder)
    }
}
