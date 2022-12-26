//
//  PrimitiveSequence+Response.swift
//  JetDevsHomeWork
//
//  Created by Developer on 24/12/22.
//

import Foundation
import Moya
import RxSwift

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {

    /**
    Returns the passed Codable-compliant object if mapping succeeds and `nil` if fails.
    */
    public func map<T: Codable>(to type: T.Type, decoder: JSONDecoder = .init()) -> Single<T> {

        return self.flatMap { (response: Response) -> Single<T> in

            do {
                let result = try decoder.decode(T.self, from: response.data)
            } catch {
                print(error)
            }
            guard let result = try? decoder.decode(T.self, from: response.data) else {
                return .error(JetdevAPIError.invalidJSONFormat)
            }
            return .just(result)
        }
    }
}
