//
//  UserCredential.swift
//  JetDevsHomeWork
//
//  Created by Developer on 24/12/22.
//

import Foundation

public struct UserCredentialRequest: Codable {

    public let email: String
    public let password: String

    public init(email: String, password: String) {

        self.email = email
        self.password = password
    }
}
