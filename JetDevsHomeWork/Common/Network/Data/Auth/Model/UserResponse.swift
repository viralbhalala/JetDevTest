//
//  UserResponse.swift
//  JetDevsHomeWork
//
//  Created by Developer on 26/12/22.
//

import Foundation

public struct UserResponse: Codable {

    enum CodingKeys: String, CodingKey {
        case data
    }

    public let data: UserData?

}

extension UserResponse {
    
    public struct UserData: Codable {
        
        enum CodingKeys: String, CodingKey {
            case user
        }
        
        public let user: User?
    }
}

extension UserResponse {

    public struct User: Codable {

        enum CodingKeys: String, CodingKey {
            case userId = "user_id"
            case userName = "user_name"
            case userProfileUrl = "user_profile_url"
            case createdAt = "created_at"
        }

        public let userId: Int?
        public let userName: String?
        public let userProfileUrl: String?
        public let createdAt: String?

        public init(userId: Int?, userName: String?, userProfileUrl: String?, createdAt: String?) {
            self.userId = userId
            self.userName = userName
            self.userProfileUrl = userProfileUrl
            self.createdAt = createdAt
        }
    }
}
