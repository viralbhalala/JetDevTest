//
//  AuthRemoteDataSource.swift
//  JetDevsHomeWork
//
//  Created by Developer on 24/12/22.
//

import Foundation
import RxSwift

protocol AuthRemoteDataSource {

    func login(with parameter: UserCredentialRequest) -> Single<UserResponse>
}
