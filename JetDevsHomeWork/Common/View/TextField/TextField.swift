//
//  JetdevProgress.swift
//  JetDevsHomeWork
//
//  Created by Developer on 24/12/22.
//
import UIKit
import RxSwift
import RxCocoa

final class TextField: NibView {

	// MARK: - Public Properties

	var actionButtonTapped: (() -> Void)?

	var shouldValueChanged: (
		(_ originalValue: String,
		 _ replaceValue: String,
		 _ newValue: String,
		 _ range: NSRange
		) -> Bool)?

	var valueChanged: Observable<String?> {
		textField.rx.text.asObservable()
	}

	var isFocusedObservable: Observable<Bool> {
		isTextFieldFocused.asObservable()
	}

	var activeTitleColor = UIColor.text {
	  didSet { configureTitleLabelColor() }
	}

	var inactiveTitleColor = UIColor.text {
	  didSet { configureTitleLabelColor() }
	}

	// MARK: - Private Properties

	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var errorLabel: UILabel!
	@IBOutlet private weak var placeholderLabel: UILabel!
	@IBOutlet private weak var textField: UITextField!
	@IBOutlet private weak var textFieldBackgroundView: UIView!
	@IBOutlet private weak var actionButton: UIButton!
	@IBOutlet private weak var textFieldTrailingConstraint: NSLayoutConstraint!
	@IBOutlet private weak var errorLabelTrailingConstraint: NSLayoutConstraint!
	@IBOutlet private weak var textFieldHeightConstraint: NSLayoutConstraint!
	@IBOutlet private weak var rightViewContentView: UIView!
	@IBOutlet private weak var rightViewImageView: UIImageView!
	@IBOutlet private weak var rightViewContentViewTrailingConstraint: NSLayoutConstraint!

	private var isShowActionButton = false
	private var isSecureText = false
	private var isShowingPassword = false
	private var maxLength: Int?
	private var maxLengthExcluding: [String] = []
	private let isTextFieldFocused = BehaviorRelay<Bool>(value: false)

	private var isEditing = false {
		didSet {
			configureTextFieldBorderColor()
			configureTitleLabelColor()
		}
	}

	// MARK: - Public Methods

	override func viewDidLoad() {

		bindTextFieldFocusState()
		bindActionButton()
		configureTextFieldBackgroundView()
		configureTextFieldBorderColor()
		setTextFieldFont(.latoRegularFont(size: 16))
	}

	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		configureTextFieldBorderColor()
	}

	func setTitle(_ title: String?) {
		titleLabel.text = title
	}

	func setValue(_ value: String?, sendValueChangedAction: Bool = true) {

		textField.text = value
		placeholderLabel.isHidden = value?.isEmpty == false

		if sendValueChangedAction {
			textField.sendActions(for: .valueChanged)
		}
	}

	func setTextFieldFont(_ font: UIFont) {
		textField.font = font
	}

	func setTextfieldHeight(_ height: CGFloat) {
		textFieldHeightConstraint.constant = height
	}

	func setMaximumLength(_ length: Int, excluding: [String] = []) {

		maxLength = length
		maxLengthExcluding = excluding
		textField.delegate = self
	}

	func setAutoCompletedEmail() {
		textField.autocorrectionType = .yes
		textField.textContentType = .emailAddress
		textField.keyboardType = .emailAddress
	}

	func setErrorLabelLeftPadding(_ padding: CGFloat) {
		errorLabelTrailingConstraint.constant = padding
	}

	func setPlaceholder(_ placeholder: String?) {
		placeholderLabel.text = placeholder
	}

	func setPlaceholderFont(_ font: UIFont) {
		placeholderLabel.font = font
	}

	func configureTextFieldBackgroundView(backgroundColor: UIColor) {
		textFieldBackgroundView.backgroundColor = backgroundColor
	}

	func setRightViewAlpha(_ alpha: CGFloat) {
		rightViewContentView.alpha = alpha
	}

	func configureRightView(_ image: UIImage?, backgroundColor: UIColor) {
		rightViewContentView.backgroundColor = backgroundColor
		rightViewImageView.image = image
		rightViewContentView.isHidden = false
		textFieldTrailingConstraint.constant = textFieldHeightConstraint.constant + 10
	}

	func setError(_ error: String?) {

		errorLabel.text = error

		configureTextFieldBorderColor()
	}

	func setClearButtonMode(_ mode: UITextField.ViewMode) {
		textField.clearButtonMode = mode
	}

	func enableCustomClearButton(mode: UITextField.ViewMode = .whileEditing) {
		let clearButton = UIButton(frame: .init(x: 0, y: 0, width: 24, height: 24))
		clearButton.setImage(UIImage(named: "iconClearText") ?? nil, for: .normal)
		clearButton.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)
		setTextFieldRightView(clearButton, mode: mode)
	}

	@objc private func clearTextField() {
		setValue("")
	}

	func setTextFieldRightView(_ view: UIView, mode: UITextField.ViewMode = .always) {
		textField.rightView = view
		textField.rightViewMode = mode
		textField.rightView?.isHidden = false
	}

	func hideTextFieldRightView(_ isHidden: Bool) {
		textField.rightView?.isHidden = isHidden
	}

	func showActionButton(_ isShow: Bool) {

		actionButton.isHidden = !isShow
		actionButton.setImage(nil, for: .init())
		rightViewContentView.isUserInteractionEnabled = false
		isShowActionButton = isShow
	}

	func setAsSecureTextEntry(_ isSecure: Bool) {

		textFieldTrailingConstraint.constant = isSecure ? 40 : 20
		isSecureText = isSecure
		textField.textColor = UIColor.text

		actionButton.isHidden = !isSecure
		configureActionButtonForSecureText()
	}

	func setKeyboardType(_ type: UIKeyboardType) {
		textField.keyboardType = type
	}

	func isBeingEditing() -> Bool {
		isTextFieldFocused.value
	}

	func hasError() -> Bool {
		guard let error = errorLabel.text else {
			return false
		}
		return !error.isEmpty
	}

	@discardableResult
	override func resignFirstResponder() -> Bool {
		return textField.resignFirstResponder()
	}

	@discardableResult
	override func becomeFirstResponder() -> Bool {
		return textField.becomeFirstResponder()
	}

	// MARK: - Private Methods

	private func bindTextFieldFocusState() {

		textField.rx.controlEvent(UIControl.Event.editingDidBegin)
			.subscribe(onNext: { [weak self] in
				self?.setError(nil)
				self?.isEditing = true
				self?.isTextFieldFocused.accept(true)
			})
			.disposed(by: disposeBag)

		textField.rx.controlEvent(UIControl.Event.editingDidEnd)
			.subscribe(onNext: { [weak self] in
				self?.isEditing = false
				self?.isTextFieldFocused.accept(false)
			})
			.disposed(by: disposeBag)

		textField.rx.text.orEmpty
			.mapNotEmpty()
			.bind(to: placeholderLabel.rx.isHidden)
			.disposed(by: disposeBag)
	}

	private func bindActionButton() {

		actionButton.rx.tap.asObservable()
			.withUnretained(self)
			.subscribe(onNext: { (view, _) in

				if view.isShowActionButton {
					view.actionButtonTapped?()
				} else if view.isSecureText {
					view.isShowingPassword.toggle()
					view.configureActionButtonForSecureText()
				}
			})
			.disposed(by: disposeBag)
	}

	private func configureActionButtonForSecureText() {

		textField.isSecureTextEntry = !isShowingPassword

		let icon = isShowingPassword ? UIImage(named: "iconEyeInctive") : UIImage(named: "iconEyeActive")

		actionButton.setImage(icon, for: .init())
	}

	private func configureTextFieldBackgroundView() {

		textFieldBackgroundView.layer.cornerRadius = 5
		textFieldBackgroundView.layer.borderWidth = 1
	}

	private func configureTextFieldBorderColor() {

		let isError = errorLabel.text?.isEmpty == false

		if isError {
			textFieldBackgroundView.layer.borderColor = UIColor.error.cgColor
		} else if isEditing {
			textFieldBackgroundView.layer.borderColor = UIColor.textFieldActiveBorder.resolvedColor(
				with: traitCollection
			).cgColor
		} else {
			textFieldBackgroundView.layer.borderColor = UIColor.textFieldInactiveBorder.resolvedColor(
				with: traitCollection).cgColor
		}
	}

	private func configureTitleLabelColor() {
	  titleLabel.textColor = isEditing ? activeTitleColor : inactiveTitleColor
	}
}

extension Reactive where Base: TextField {

	var value: Binder<String?> {
		Binder(base) { (textField, text) in
			textField.setValue(text)
		}
	}

	var title: Binder<String?> {
		Binder(base) { (textField, text) in
			textField.setTitle(text)
		}
	}

	var placeholder: Binder<String?> {
		Binder(base) { (textField, text) in
			textField.setPlaceholder(text)
		}
	}

	var error: Binder<String?> {
		Binder(base) { (textField, text) in
			textField.setError(text)
		}
	}
}

extension TextField: UITextFieldDelegate {

	func textField(
		_ textField: UITextField,
		shouldChangeCharactersIn range: NSRange,
		replacementString string: String) -> Bool {

		guard let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else {
			return false
		}

		var cleanedText = newText
		for item in maxLengthExcluding {
			cleanedText = cleanedText.replacingOccurrences(of: item, with: "")
		}

		if let validMaxLength = maxLength, cleanedText.count > validMaxLength {
			setValue(String(cleanedText.prefix(validMaxLength)), sendValueChangedAction: true)
			return false
		}

		if let shouldValueChanged = shouldValueChanged, let text = textField.text {
			return shouldValueChanged(text, string, newText, range)
		}

		return true
	}
}
