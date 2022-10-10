//
//  UIView+Rounded.swift
//  VaccineCenter
//
//  Created by Doyoung on 2022/10/10.
//

import UIKit

extension UIView {
    func rounded(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
