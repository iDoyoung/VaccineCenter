//
//  VaccineCenterContentView.swift
//  VaccineCenter
//
//  Created by Doyoung on 2022/10/10.
//

import UIKit
import SnapKit

class VaccineCenterContentView: UIView {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    private func configure() {
        self.shadow()
        self.rounded(10)
        backgroundColor = .systemBackground
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(contentLabel)
        setupLayoutConstraints()
    }
    private func setupLayoutConstraints() {
        imageView.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.top.equalToSuperview().offset(20)
            make.bottom.equalTo(titleLabel.snp.top).offset(-16)
            make.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(snp.centerY)
            make.centerX.equalToSuperview()
        }
        contentLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
}
