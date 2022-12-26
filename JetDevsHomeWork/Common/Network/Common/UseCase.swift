//
//  UseCase.swift
//  JetDevsHomeWork
//
//  Created by Developer on 24/12/22.
//

import Foundation
import RxSwift

public protocol UseCase {

    associatedtype Result
    associatedtype Parameters

    static func make() -> Self

    func execute(with parameters: Parameters) -> Single<Result>
}

public struct AnyUseCase<Result, Parameters>: UseCase {

    private let execution: (Parameters) -> Single<Result>

    public init<WrappedUseCase: UseCase>(
        _ wrappedUseCase: WrappedUseCase
    ) where WrappedUseCase.Result == Result, WrappedUseCase.Parameters == Parameters {
        self.execution = wrappedUseCase.execute(with:)
    }

    public static func make() -> AnyUseCase {
        fatalError("calling make() on AnyUseCase is not supported")
    }

    public func execute(with parameters: Parameters) -> Single<Result> {
        execution(parameters)
    }
}
