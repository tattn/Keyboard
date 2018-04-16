//
//  Keyboard.swift
//  Keyboard
//
//  Created by Tatsuya Tanaka on 20180416.
//  Copyright © 2018年 tattn. All rights reserved.
//

import UIKit

@objcMembers
public final class Keyboard: NSObject {
    public static let shared = Keyboard()

    public weak var window: UIWindow?
    private var windowOrKeyWindow: UIWindow? { return window ?? UIApplication.shared.keyWindow }

    public enum Option {
        case autoScroll
        case closeOnTapOther
        public static var allCases: [Option] { return [.autoScroll, .closeOnTapOther] }
    }
    private var enabledOptions = Set(Option.allCases)

    private var keyboardClosingGesture: UILongPressGestureRecognizer?

    required public override init() {
        super.init()
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        notification.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }

    public func enable(options: Set<Option> = .init(Option.allCases)) {
        enabledOptions = options
    }

    public func disable(options: Set<Option> = .init(Option.allCases)) {
        enabledOptions.subtract(options)
    }

    private func scrollWindowUntilInputViewIsVisible(notification: Notification) {
        guard
            let window = self.windowOrKeyWindow,
            let firstResponder = window.firstResponder,
            let inputViewMaxY = firstResponder.superview?.convert(firstResponder.frame, to: window).maxY,
            let keyboardRect = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect
            else { return }

        let y: CGFloat
        if inputViewMaxY < window.frame.height - keyboardRect.height {
            y = 0
        } else {
            y = inputViewMaxY - (window.frame.height - keyboardRect.height)
        }

        let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0
        UIView.animate(withDuration: duration) {
            let transform = CGAffineTransform(translationX: 0, y: -y)
            window.transform = transform
        }
    }

    private func revertToScrollWindowUntilInputViewIsVisible(notification: Notification) {
        guard let window = self.windowOrKeyWindow else { return }
        let duration = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? TimeInterval ?? 0
        UIView.animate(withDuration: duration) {
            window.transform = CGAffineTransform.identity
        }
    }

    private func addKeyboardClosingGesture() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(onKeyboardClosingGesture))
        gesture.minimumPressDuration = 0
        windowOrKeyWindow?.addGestureRecognizer(gesture)
        keyboardClosingGesture = gesture
    }

    private func removeKeyboardClosingGesture() {
        keyboardClosingGesture.map { $0.view?.removeGestureRecognizer($0) }
    }
}

@objc extension Keyboard {
    private func keyboardWillShow(notification: Notification) {
        if enabledOptions.contains(.autoScroll) {
            scrollWindowUntilInputViewIsVisible(notification: notification)
        }
        if enabledOptions.contains(.closeOnTapOther) {
            addKeyboardClosingGesture()
        }
    }

    private func keyboardWillHide(notification: Notification) {
        if enabledOptions.contains(.autoScroll) {
            revertToScrollWindowUntilInputViewIsVisible(notification: notification)
        }
        if enabledOptions.contains(.closeOnTapOther) {
            removeKeyboardClosingGesture()
        }
    }

    private func onKeyboardClosingGesture() {
        windowOrKeyWindow?.firstResponder?.resignFirstResponder()
    }
}
