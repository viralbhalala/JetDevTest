//
//  AuthTargetType.swift
//  JetDevsHomeWork
//
//  Created by Developer on 24/12/22.
//

import Foundation
import Moya

enum AuthTargetType {
    case login(parameter: UserCredentialRequest)
}

extension AuthTargetType: JetDevEndpoint {

    var parameters: [String: Any] {

        switch self {
        case .login(let parameter):
            return parameter.toJSON()
        }
    }

    var path: String {

        switch self {
        case .login:
            return "/login"
        }
    }

    var method: Moya.Method {

        switch self {
        case .login:
            return .post
        }
    }

    var parameterEncoding: ParameterEncoding {

        switch self {
        case .login:
            return JSONEncoding.default
        }
    }

    var authorizationType: AuthorizationType? {

        switch self {
        case .login:
            return .none
        }
    }
}
