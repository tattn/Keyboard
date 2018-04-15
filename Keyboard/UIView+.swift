//
//  UIView+.swift
//  Keyboard
//
//  Created by Tatsuya Tanaka on 20180416.
//  Copyright © 2018年 tattn. All rights reserved.
//

import UIKit

extension UIView {
    var firstResponder: UIView? {
        guard !isFirstResponder else { return self }

        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }

        return nil
    }
}
