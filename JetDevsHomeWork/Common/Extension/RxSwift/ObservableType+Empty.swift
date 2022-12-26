//
//  ObservableType+Empty.swift
//  JetDevsHomeWork
//
//  Created by Developer on 24/12/22.
//

import Foundation
import RxSwift

extension ObservableType where Element == String {

    public func filterNotEmpty() -> Observable<Element> {

        filter { (text) -> Bool in
            !text.isEmpty
        }
    }

    public func filterEmpty() -> Observable<Element> {

        filter { (text) -> Bool in
            text.isEmpty
        }
    }

    public func mapEmpty() -> Observable<Bool> {

        map { (text) -> Bool in
            text.isEmpty
        }
    }

    public func mapNotEmpty() -> Observable<Bool> {

        map { (text) -> Bool in
            !text.isEmpty
        }
    }
}
