//
//  BaseViewController.swift
//  JetDevsHomeWork
//
//  Created by Developer on 24/12/22.
//

import UIKit

import RxSwift

final class RotationRestrictedNavigationController: UINavigationController {

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

class BaseViewController: UIViewController {

    let disposeBag = DisposeBag()

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    init() {

        let nibName = String(describing: type(of: self))
        let bundle = Bundle(for: type(of: self))

        super.init(nibName: nibName, bundle: bundle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
