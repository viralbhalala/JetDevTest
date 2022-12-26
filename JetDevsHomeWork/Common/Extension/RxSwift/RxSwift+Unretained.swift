//
//  RxSwift+Unretained.swift
//  JetDevsHomeWork
//
//  Created by Developer on 24/12/22.
//

import Foundation
import RxSwift

extension ObservableType {

    public func withUnretained<T: AnyObject>(_ owner: T) -> Observable<(T, Element)> {

        flatMap { [weak owner] (element) -> Observable<(T, Element)> in

            guard let owner = owner else {
                return .empty()
            }
            return .just((owner, element))
        }
    }
}

extension PrimitiveSequenceType where Trait == SingleTrait {

    public func withUnretained<T: AnyObject>(_ owner: T) -> Single<(T, Element)> {

        flatMap { [weak owner] (element) in

            guard let owner = owner else {
                return .never()
            }
            return .just((owner, element))
        }
    }
}
