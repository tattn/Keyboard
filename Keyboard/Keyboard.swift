//
//  Keyboard.swift
//  Keyboard
//
//  Created by Tatsuya Tanaka on 20180416.
//  Copyright © 2018年 tattn. All rights reserved.
//

import UIKit

public struct Keyboard {
    public static let shared = Keyboard()

    public weak var window: UIWindow?
    private var windowOrKeyWindow: UIWindow? { return window ?? UIApplication.shared.keyWindow }

    private let delegator = Delegator()

    private init() {
        delegator.onKeyboardWillShow = keyboardWillShow
        delegator.onKeyboardWillHide = keyboardWillHide
    }

    public func enable() {
        let notification = NotificationCenter.default
        notification.addObserver(delegator, selector: #selector(Delegator.keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        notification.addObserver(delegator, selector: #selector(Delegator.keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
}

extension Keyboard {
    private func keyboardWillShow(notification: Notification?) {
        guard
            let window = self.windowOrKeyWindow,
            let firstResponder = window.firstResponder,
            let inputViewMaxY = firstResponder.superview?.convert(firstResponder.frame, to: window).maxY,
            let keyboardRect = (notification?.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else { return }


        let y: CGFloat
        if inputViewMaxY < window.frame.height - keyboardRect.height {
            y = 0
        } else {
            y = inputViewMaxY - (window.frame.height - keyboardRect.height)
        }

        let duration = notification?.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0
        UIView.animate(withDuration: duration) {
            let transform = CGAffineTransform(translationX: 0, y: -y)
            window.transform = transform
        }
    }

    private func keyboardWillHide(notification: Notification?) {
        guard let window = self.windowOrKeyWindow else { return }
        let duration = notification?.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? TimeInterval ?? 0
        UIView.animate(withDuration: duration) {
            window.transform = CGAffineTransform.identity
        }
    }
}

extension Keyboard {
    private class Delegator: NSObject {
        var onKeyboardWillShow: ((_ notification: Notification?) -> Void)?
        var onKeyboardWillHide: ((_ notification: Notification?) -> Void)?

        @objc func keyboardWillShow(notification: Notification?) {
            onKeyboardWillShow?(notification)
        }

        @objc func keyboardWillHide(notification: Notification?) {
            onKeyboardWillHide?(notification)
        }
    }
}
