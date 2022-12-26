//
//  Moya+Request.swift
//  JetDevsHomeWork
//
//  Created by Developer on 24/12/22.
//

import Foundation
import Moya
import RxSwift

extension MoyaProvider {

    public func requestWithValidation(
        _ target: Target,
        maxRetryAttempt: Int = 1,
        retryInterval: RxTimeInterval = .seconds(1)
    ) -> Single<Response> {

        let requestSingle = self.rx.request(target)
            .do(onError: { (error) in
                
            })
            .catchError { _ -> Single<Response> in
                return Single<Response>.error(JetdevAPIError.unknown)
            }
            .flatMap { (response: Response) -> Single<Response> in

                let responseSuccess: CountableRange<Int> = (200..<300)

                switch response.statusCode {
                case responseSuccess:
                    
                    guard var apiResponse = try? JSONDecoder().decode(APIErrorResponse.self, from: response.data) else {

                        return .error(JetdevAPIError.unknown)
                    }
                    if apiResponse.code == 1 {
                        return .just(response)
                    } else {
                        return .error(apiResponse.jetdevAPIError)
                    }

                default:
                    guard var apiResponse = try? JSONDecoder().decode(APIErrorResponse.self, from: response.data) else {
                        return .error(JetdevAPIError.unknown)
                    }
                    apiResponse.statusCode = response.statusCode
                    return .error(apiResponse.jetdevAPIError)
                }
            }
            .retryWhen { [weak self] errors in
                self?.retryIfNeeded(with: errors, maxAttempt: maxRetryAttempt, interval: retryInterval) ?? .empty()
            }

        return requestSingle
    }

    private func retryIfNeeded(
        with errors: Observable<Error>,
        maxAttempt: Int,
        interval: RxTimeInterval
    ) -> Observable<Int> {

        errors.enumerated().flatMap { [weak self] (index, error) -> Observable<Int> in

            if index < maxAttempt && self?.isRetryable(error) == true {
                return Observable.timer(interval, scheduler: MainScheduler.instance)
            } else {
                return Observable.error(error)
            }
        }
    }

    private func isRetryable(_ error: Error) -> Bool {

        switch error as? JetdevAPIError {
        case .systemError, .unknown:
            return true

        default:
            return false
        }
    }
}
