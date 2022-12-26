//
//  JetdevAPIError.swift
//  JetDevsHomeWork
//
//  Created by Developer on 24/12/22.
//

import Foundation

public enum JetdevAPIError: Error, Equatable {
    
    case systemError(message: String?)
    case unknown
    case invalidJSONFormat
}

extension JetdevAPIError {

    enum APIErrorCodes: Int {
        case success = 1
        case error = 0
    }
    
    static func from<T: Error>(error: T) -> JetdevAPIError {
        switch error {
        case let jetdevError as JetdevAPIError:
            return jetdevError
        case let apiError as APIErrorResponse:
            return apiError.jetdevAPIError
        default:
            return JetdevAPIError.unknown
        }
    }

    public struct FieldError: Codable, Equatable {

        let name: String?
        let error: String?
    }
}
