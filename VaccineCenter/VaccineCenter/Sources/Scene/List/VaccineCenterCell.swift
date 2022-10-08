//
//  VaccineCenterCell.swift
//  VaccineCenter
//
//  Created by Doyoung on 2022/10/08.
//

import UIKit
import SnapKit

final class VaccineCenterCell: UITableViewCell {
    lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [configureHorizontalStackView(title: "센터명", content: ""),
                                                       configureHorizontalStackView(title: "건물명", content: ""),
                                                       configureHorizontalStackView(title: "주소", content: ""),
                                                       configureHorizontalStackView(title: "업데이트 시간", content: "")])
        stackView.axis = .vertical
        return stackView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        return label
    }()
    private let contentLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configureHorizontalStackView(title: String, content: String) -> UIStackView {
        let titleLabel = titleLabel
        let contentLabel = contentLabel
        titleLabel.text = title
        contentLabel.text = content
        let stackView = UIStackView(arrangedSubviews: [titleLabel, contentLabel])
        stackView.axis = .horizontal
        return stackView
    }
    private func configure() {
        contentView.addSubview(verticalStackView)
        verticalStackView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
    }
}
