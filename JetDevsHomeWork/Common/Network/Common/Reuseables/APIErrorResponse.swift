//
//  APIErrorResponse.swift
//  JetDevsHomeWork
//
//  Created by Developer on 24/12/22.
//

import Foundation

struct APIErrorResponse: Codable, Equatable {

    enum CodingKeys: String, CodingKey {
        case code = "result"
        case message = "error_message"
        case errors
        case expiredAt = "expires_at"
        case fields
    }
    
    let code: Int?
    let message: String?
    let expiredAt: String?
    let errors: [String]?
    let fields: [APIFieldError]?

    var statusCode: Int?

    var jetdevAPIError: JetdevAPIError {
        
        switch JetdevAPIError.APIErrorCodes(rawValue: code ?? 0) {
        case .error:
            return .systemError(message: message.orEmpty)
            
        default:
            break
        }
        
        switch self.statusCode {
        case 500:
            return .systemError(message: message.orEmpty)
        default:
            break
        }
        
        return .unknown
    }
    
    public static func == (lhs: APIErrorResponse, rhs: APIErrorResponse) -> Bool {
        return lhs.code == rhs.code && lhs.statusCode == rhs.statusCode
    }
}

extension APIErrorResponse {

    struct APIFieldError: Codable, Equatable {

        let name: String?
        let error: String?
        
        func toJetdevAPIErrorField() -> JetdevAPIError.FieldError {
            JetdevAPIError.FieldError(name: name, error: error)
        }
    }
}
