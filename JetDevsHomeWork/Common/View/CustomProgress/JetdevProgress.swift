//
//  JetdevProgress.swift
//  JetDevsHomeWork
//
//  Created by Developer on 24/12/22.
//

import Foundation
import SVProgressHUD

final class JetdevProgress {

    static func show(
        statusText: String = "please_wait".localized(),
        allowInteraction: Bool = false
    ) {

        // Need to manually handle the foreground color like this.
        // Because SVProgressHUD seems unable to play with dynamic color asset.
        if let window = (UIApplication.shared.delegate as? AppDelegate)?.window {

            switch (window.overrideUserInterfaceStyle, UIScreen.main.traitCollection.userInterfaceStyle) {
            case (.dark, _):
                SVProgressHUD.setForegroundColor(.white)

            case (.light, _):
                SVProgressHUD.setForegroundColor(allowInteraction ? .black : .white)

            case (.unspecified, .dark):
                SVProgressHUD.setForegroundColor(.white)

            case (.unspecified, .light):
                SVProgressHUD.setForegroundColor(allowInteraction ? .black : .white)

            default:
                SVProgressHUD.setForegroundColor(.white)
            }
        }

        SVProgressHUD.setBackgroundColor(.clear)
        SVProgressHUD.setRingThickness(5.0)
        SVProgressHUD.setRingRadius(25.0)
        SVProgressHUD.setFont(UIFont.latoRegularFont(size: 14.0))
        SVProgressHUD.setDefaultMaskType(allowInteraction ? .none : .black)
        SVProgressHUD.show(withStatus: statusText)
    }

    static func dismiss() {

        SVProgressHUD.dismiss()
    }
}
