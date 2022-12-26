//
//  JetDevEndpoint.swift
//  JetDevsHomeWork
//
//  Created by Developer on 24/12/22.
//

import Foundation
import Moya

protocol JetDevEndpoint: TargetType, AccessTokenAuthorizable {

    var parameters: [String: Any] { get }

    var parameterEncoding: Moya.ParameterEncoding { get }
}

extension JetDevEndpoint {

    var baseURL: URL {
        JetDevKit.shared.environment.baseURL
    }

    var sampleData: Data {
        Data()
    }

    var parameters: [String: Any] {
        [:]
    }

    var parameterEncoding: Moya.ParameterEncoding {
        JSONEncoding.default
    }

    var task: Task {
        return .requestParameters(parameters: parameters, encoding: parameterEncoding)
    }

    // TODO: Implement default HTTP header for all enpoints here
    var headers: [String: String]? {
        return nil
    }
}
