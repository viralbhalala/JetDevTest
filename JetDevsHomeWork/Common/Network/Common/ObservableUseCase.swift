//
//  ObservableUseCase.swift
//  JetDevsHomeWork
//
//  Created by Developer on 24/12/22.
//

import Foundation
import RxSwift

public protocol ObservableUseCase {

    associatedtype Result
    associatedtype InitialParameters
    associatedtype Parameters

    static func make() -> Self

    func observe(with initialParameters: InitialParameters) -> Observable<Result>

    func send(_ parameters: Parameters)

    func dispose()
}

extension ObservableUseCase {

    // Provide empty implementation since not every `ObservableUseCase` has to handle this.
    public func dispose() {
    }
}

public struct AnyObservableUseCase<Result, InitialParameters, Parameters>: ObservableUseCase {

    private let observation: (InitialParameters) -> Observable<Result>
    private let submission: (Parameters) -> Void
    private let cancellation: () -> Void

    public init<WrappedUseCase: ObservableUseCase>(
        _ wrappedUseCase: WrappedUseCase
    ) where
        WrappedUseCase.Result == Result,
        WrappedUseCase.Parameters == Parameters,
        WrappedUseCase.InitialParameters == InitialParameters
    {
        self.observation = wrappedUseCase.observe(with:)
        self.submission = wrappedUseCase.send
        self.cancellation = wrappedUseCase.dispose
    }

    public static func make() -> AnyObservableUseCase {
        fatalError("calling make() on AnyObservableUseCase is not supported")
    }

    public func observe(with initialParameters: InitialParameters) -> Observable<Result> {
        observation(initialParameters)
    }

    public func send(_ parameters: Parameters) {
        submission(parameters)
    }

    public func dispose() {
        cancellation()
    }
}
