//
//  PrimitiveSequence+ToOptional.swift
//  JetDevsHomeWork
//
//  Created by Developer on 24/12/22.
//

import Foundation
import RxSwift

extension PrimitiveSequence where Trait == SingleTrait {

    func toOptionalElement() -> Single<Element?> {
        self.map { elem -> Element? in
            return elem
        }
    }
}
