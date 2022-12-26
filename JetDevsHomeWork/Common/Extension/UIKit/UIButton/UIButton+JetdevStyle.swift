//
//  UIButton+JetdevStyle.swift
//  JetDevsHomeWork
//
//  Created by Developer on 24/12/22.
//

import UIKit

extension UIButton {

    func apply(style: Style) {

        setTitleColor(style.titleColor, for: .init())
        backgroundColor = style.backgroundColor
        layer.borderWidth = (style.borderWidth ?? 0)
        layer.borderColor = style.borderColor?.cgColor
        layer.cornerRadius = style.radius
    }
}

extension UIButton {

    struct Style {
        
        let titleColor: UIColor
        let backgroundColor: UIColor?
        let borderColor: UIColor?
        let borderWidth: CGFloat?
        var radius: CGFloat = 6
    }
}

extension UIButton.Style {

    static func primary() -> UIButton.Style {

        return UIButton.Style(
            titleColor: .primaryButtonText,
            backgroundColor: UIColor.primary,
            borderColor: nil,
            borderWidth: nil
        )
    }

    static func secondary() -> UIButton.Style {

        return UIButton.Style(
            titleColor: .secondaryButtonText,
            backgroundColor: .secondary,
            borderColor: nil,
            borderWidth: nil
        )
    }

    static func bordered(accentColor: UIColor = .buttonBorder) -> UIButton.Style {

        return UIButton.Style(
            titleColor: accentColor,
            backgroundColor: nil,
            borderColor: accentColor,
            borderWidth: 1
        )
    }

    static func disabled() -> UIButton.Style {

        return UIButton.Style(
            titleColor: .disabledButtonText,
            backgroundColor: .disabled,
            borderColor: nil,
            borderWidth: nil
        )
    }

}
