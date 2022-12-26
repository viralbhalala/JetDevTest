//
//  Moya+Default.swift
//  JetDevsHomeWork
//
//  Created by Developer on 24/12/22.
//

import Foundation
import Alamofire
import Moya
import RxSwift

extension MoyaProvider {

    // MARK: - Public Properties

    public static func defaultProvider(
        with configuration: URLSessionConfiguration? = JetDevKit.shared.urlSessionConfiguration
    ) -> MoyaProvider {

        MoyaProvider(
            session: defaultSession(with: configuration ?? makeURLSessionConfiguration()),
            plugins: []
        )
    }

    // MARK: - Private Properties

    private static func defaultSession(
        with configuration: URLSessionConfiguration
    ) -> Alamofire.Session {

        let session = Alamofire.Session(
            configuration: configuration
        )

        return session
    }
}

// Make instance of `URLSessionConfiguration` that completely disable system level caching for HTTP traffic.
func makeURLSessionConfiguration() -> URLSessionConfiguration {

    let configuration = URLSessionConfiguration.af.default
    configuration.urlCache = nil

    return configuration

}
