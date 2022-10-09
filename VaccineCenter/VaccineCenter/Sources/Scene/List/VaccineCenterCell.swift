//
//  VaccineCenterCell.swift
//  VaccineCenter
//
//  Created by Doyoung on 2022/10/08.
//

import UIKit
import SnapKit

final class VaccineCenterCell: UITableViewCell {
    static let reuseIdenetifier = "VaccineCenterCellReuseIdentifier"
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [addTitleLabel("센터명"),
                                                       addTitleLabel("건물명"),
                                                       addTitleLabel("주소"),
                                                       addTitleLabel("업데이트 시간")])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 10
        return stackView
    }()
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [centerNameLabel,
                                                       buildingNameLabel,
                                                       addressLabel,
                                                       updateTimeLabel])
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 10
        return stackView
    }()
    private let centerNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    private let buildingNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    private let updateTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    private func addTitleLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.text = text
        return label
    }
    func setupContentLabelText(by vaccineCenter: VaccineCenterModel.Response.Center) {
        centerNameLabel.text = vaccineCenter.centerName
        buildingNameLabel.text = vaccineCenter.facilityName
        addressLabel.text = vaccineCenter.address
        updateTimeLabel.text = vaccineCenter.updatedAt
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func configure() {
        contentView.addSubview(titleStackView)
        contentView.addSubview(contentStackView)
        titleStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.width.equalTo(100)
        }
        contentStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.leading.equalTo(titleStackView.snp.trailing).offset(4)
        }
    }
}
