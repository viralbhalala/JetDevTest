//
//  JetdevProgress.swift
//  JetDevsHomeWork
//
//  Created by Developer on 24/12/22.
//

import UIKit
import RxSwift

class NibView: UIView {

	let disposeBag = DisposeBag()
	let viewModelChanged = PublishSubject<Void>()

	// MARK: - Private Properties

	@IBOutlet weak var contentView: UIView!

	// MARK: - Initialization

	override init(frame: CGRect) {
		super.init(frame: frame)

		loadContentView()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)

		loadContentView()
	}

	deinit {
		viewModelChanged.onCompleted()
	}

	// MARK: - Public Methods

	open func viewDidLoad() {
	}

	// MARK: - Private Methods

	private func loadContentView() {

		UIView.loadFromNib(nibClass: Self.self, owner: self)

		guard let contentView = contentView else {
			return
		}

		addSubview(contentView)

		contentView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			contentView.topAnchor.constraint(equalTo: self.topAnchor),
			contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
			contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
		])

		viewDidLoad()
	}
}
