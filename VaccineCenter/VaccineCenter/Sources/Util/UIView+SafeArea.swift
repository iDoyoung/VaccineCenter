//
//  UIView+SafeArea.swift
//  VaccineCenter
//
//  Created by Doyoung on 2022/10/08.
//

import UIKit
import SnapKit

extension UIView {
    var safeArea: ConstraintLayoutGuideDSL {
       safeAreaLayoutGuide.snp
    }
}
