//
//  ViewModel.swift
//  JetDevsHomeWork
//
//  Created by Developer on 24/12/22.
//

import Foundation
import RxSwift

protocol ViewModel: AnyObject {

    associatedtype State: ViewModelState
    associatedtype Event: ViewModelEvent

    var state: Observable<State> { get }

    func onReceiveEvent(_ event: Event)
}

protocol ViewModelState {
    
}

protocol ViewModelEvent {
    
}

final class AnyViewModel<State: ViewModelState, Event: ViewModelEvent>: ViewModel {

    // MARK: - Public Properties

    let state: Observable<State>

    // MARK: - Private Properties

    private let eventHandler: (Event) -> Void

    // MARK: - Initialization

    init<WrappedViewModel: ViewModel>(
        _ wrappedViewModel: WrappedViewModel
    ) where WrappedViewModel.State == State, WrappedViewModel.Event == Event {

        self.state = wrappedViewModel.state
        self.eventHandler = wrappedViewModel.onReceiveEvent
    }

    // MARK: - Public Methods

    func onReceiveEvent(_ event: Event) {
        eventHandler(event)
    }
}
