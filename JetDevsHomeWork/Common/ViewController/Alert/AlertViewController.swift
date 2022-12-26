//
//  AlertViewController.swift
//  JetDevsHomeWork
//
//  Created by Developer on 24/12/22.
//

import UIKit

final class AlertViewController: BaseViewController {

    // MARK: - Private Properties

    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var buttonsStackView: UIStackView!
    @IBOutlet private weak var buttonsStackHeightConstraint: NSLayoutConstraint!

    private let configuration: Configuration

    // MARK: - Initialization

    init(configuration: Configuration) {
        self.configuration = configuration
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)

        configureContent()
        configureActionButtons()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        let touch: UITouch? = touches.first

        let notOnTheContentView = (touch?.view == backgroundView)
        let notPresentingSomething = self.presentedViewController == nil

        if notOnTheContentView && notPresentingSomething && configuration.dismissOnTouchOutside {
            close()
            configuration.onTouchOutsideDismissed?()
        }
    }

    func show(in viewController: UIViewController) {

        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve

        viewController.present(self, animated: false) {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in

                self?.contentView.transform = .identity

                self?.view.layoutIfNeeded()
                self?.view.alpha = 1
            })
        }
    }

    func close(animated: Bool = true, completion: (() -> Void)? = nil) {

        guard animated else {

            view.alpha = 0
            dismiss(animated: false, completion: completion)

            return
        }

        UIView.animate(
            withDuration: 0.3,
            animations: { [weak self] in
                self?.view.alpha = 0
            }, completion: { [weak self] _ in
                self?.dismiss(animated: false, completion: completion)
            }
        )
    }

    // MARK: - Private Methods

    private func configureContent() {

        titleLabel.text = configuration.title

        let message = NSMutableAttributedString(attributedString: configuration.attributedMessage)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.lineSpacing = 4
        paragraphStyle.alignment = .center

        messageLabel.attributedText = message.withParagraphStyle(paragraphStyle)
    }

    private func configureActionButtons() {

        if let action = configuration.negativeAction {

            buttonsStackView.axis = configuration.buttonsStackOrientation == .horizontal ? .horizontal : .vertical

            switch configuration.buttonsStackOrientation {
            case .horizontal:
                buttonsStackHeightConstraint.constant = 40

            case .vertical:
                let interButtonsSpacing: CGFloat = 10
                let buttonHeight: CGFloat = 40
                buttonsStackHeightConstraint.constant = (buttonHeight * 2) + interButtonsSpacing
            }

            buttonsStackView.addArrangedSubview(
                createButton(with: action, style: .secondary())
            )
        }

        buttonsStackView.addArrangedSubview(
            createButton(with: configuration.positiveAction, style: .primary())
        )
    }

    private func createButton(with action: Action, style: UIButton.Style) -> UIButton {

        let button = UIButton(frame: .zero)

        button.setTitle(action.title, for: .init())
        button.apply(style: style)
        button.titleLabel?.font = action.font

        button.rx.tap.asObservable()
            .withUnretained(self)
            .subscribe(onNext: { (alert, _) in

                if action.dismissOnTapped {
                    alert.close(animated: true) {
                        action.handler?()
                    }
                } else {
                    action.handler?()
                }
            })
            .disposed(by: disposeBag)

        return button
    }
}

extension AlertViewController {

    struct Configuration {
        let title: String
        let attributedMessage: NSAttributedString
        let positiveAction: Action
        var negativeAction: Action?
        var buttonsStackOrientation: Action.Orientation = .horizontal
        var dismissOnTouchOutside: Bool = true
        var onTouchOutsideDismissed: (() -> Void)?
    }

    struct Action {
        let title: String
        var font: UIFont = .latoSemiBoldFont(size: 16)
        var dismissOnTapped = true
        var handler: (() -> Void)?

        enum Orientation {
            case vertical
            case horizontal
        }
    }
}

extension AlertViewController.Configuration {

    init(
        title: String,
        message: String,
        positiveAction: AlertViewController.Action,
        negativeAction: AlertViewController.Action? = nil,
        buttonsStackOrientation: AlertViewController.Action.Orientation = .horizontal,
        dismissOnTouchOutside: Bool = true,
        onTouchOutsideDismissed: (() -> Void)? = nil
    ) {

        self.init(
            title: title,
            attributedMessage: NSAttributedString(string: message),
            positiveAction: positiveAction,
            negativeAction: negativeAction,
            buttonsStackOrientation: buttonsStackOrientation,
            dismissOnTouchOutside: dismissOnTouchOutside,
            onTouchOutsideDismissed: onTouchOutsideDismissed
        )
    }
}
