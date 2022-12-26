//
//  JetDevKit.swift
//  JetDevsHomeWork
//
//  Created by Developer on 24/12/22.
//

import Foundation
import Alamofire

public final class JetDevKit {

    // MARK: - Public Properties

    public static let shared = JetDevKit()

    // MARK: - Private Properties

    public private(set) var environment: Environment = .production
    public private(set) var urlSessionConfiguration: URLSessionConfiguration?

    // MARK: - Initialization

    private init() {
    }

    // MARK: - Public Methods

    public func configure(
        environment: Environment,
        urlSessionConfiguration: URLSessionConfiguration? = nil
    ) {

        self.environment = environment
        self.urlSessionConfiguration = urlSessionConfiguration
    }
}

extension JetDevKit {

    public enum Environment {
        case production
        
        var secure: Bool {

            switch self {
            case .production:
                return true
            }
        }

        var serverAddress: String {
            switch self {
            case .production:
                return "3d02g.mocklab.io"
            }
        }

        var baseURL: URL {
            let proto = self.secure ? "https://" : "http://"
            return URL(string: "\(proto)\(serverAddress)")!
        }
    }
}
