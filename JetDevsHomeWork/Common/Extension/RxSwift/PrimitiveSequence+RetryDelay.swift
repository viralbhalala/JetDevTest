//
//  PrimitiveSequence+RetryDelay.swift
//  JetDevsHomeWork
//
//  Created by Developer on 24/12/22.
//

import Foundation
import RxSwift

extension PrimitiveSequence {
  func retry(maxAttempts: Int, delay: TimeInterval) -> PrimitiveSequence<Trait, Element> {
    return self.retryWhen { errors in
      return errors.enumerated().flatMap { (index, error) -> Observable<Int64> in
        if index <= maxAttempts {
            return Observable<Int64>.timer(.seconds(Int(delay)), scheduler: MainScheduler.instance)
        } else {
          return Observable.error(error)
        }
      }
    }
  }
}
