//
//  UIView+Shadow.swift
//  VaccineCenter
//
//  Created by Doyoung on 2022/10/10.
//

import UIKit

extension UIView {
    func shadow() {
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 9
        self.layer.shadowOpacity = 0.4
        self.layer.masksToBounds = false
    }
}
