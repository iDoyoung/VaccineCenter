//
//  DetailVaccineCenter.swift
//  VaccineCenter
//
//  Created by Doyoung on 2022/10/08.
//

import UIKit
import RxSwift
import RxCocoa

final class DetailVaccineCenterViewController: UIViewController {
    
    private var disposeBag = DisposeBag()
    var viewModel: DetailVaccineCenterViewModelProtocol?
    //MARK: - UI Properties
    private let centerNameView: VaccineCenterContentView = {
        let view = VaccineCenterContentView()
        view.imageView.image = UIImage(named: "hospital")
        view.titleLabel.text = "센터명"
        return view
    }()
    
    private let buildingNameView: VaccineCenterContentView = {
        let view = VaccineCenterContentView()
        view.imageView.image = UIImage(named: "building")
        view.titleLabel.text = "건물명"
        return view
    }()
    
    private let phoneNumberView: VaccineCenterContentView = {
        let view = VaccineCenterContentView()
        view.imageView.image = UIImage(named: "telephone")
        view.titleLabel.text = "전화번호"
        return view
    }()
    
    private let updateTimeView: VaccineCenterContentView = {
        let view = VaccineCenterContentView()
        view.imageView.image = UIImage(named: "chat")
        view.titleLabel.text = "업데이트 시간"
        return view
    }()
    
    private let addressView: VaccineCenterContentView = {
        let view = VaccineCenterContentView()
        view.imageView.image = UIImage(named: "placeholder")
        view.titleLabel.text = "주소"
        return view
    }()
    
    //MARK: - Life Cycle
    override func loadView() {
        view = UIView()
        view.backgroundColor = .secondarySystemBackground
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        configureUIComponents()
        guard let viewModel = viewModel else { return }
        bind(to: viewModel)
    }
    //MARK: Configure
    private func bind(to viewModel: DetailVaccineCenterViewModelOutput) {
        viewModel.centerName
            .subscribe(onNext: { [weak self] centerName in
                self?.title = centerName
                self?.centerNameView.contentLabel.text = centerName
            })
            .disposed(by: disposeBag)
        
        viewModel.buildingName
            .bind(to: buildingNameView.contentLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.phoneNumber
            .bind(to: phoneNumberView.contentLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.updateTime
            .bind(to: updateTimeView.contentLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.address
            .bind(to: addressView.contentLabel.rx.text)
            .disposed(by: disposeBag)
    }
    //MARK: - Setup
    private func setupNavigationBar() {
        title = ""
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "지도", style: .plain, target: self, action: #selector(showLocation))
    }
    private func configureUIComponents() {
        view.addSubview(centerNameView)
        view.addSubview(buildingNameView)
        view.addSubview(phoneNumberView)
        view.addSubview(updateTimeView)
        view.addSubview(addressView)
        setupLayoutConstraints()
    }
    private func setupLayoutConstraints() {
        centerNameView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(view.snp.centerX).offset(-10)
            make.top.equalTo(view.safeArea.top).offset(20)
        }
        buildingNameView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.centerX).offset(10)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(view.safeArea.top).offset(20)
        }
        phoneNumberView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(view.snp.centerX).offset(-10)
            make.top.equalTo(centerNameView.snp.bottom).offset(20)
        }
        updateTimeView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.centerX).offset(10)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(buildingNameView.snp.bottom).offset(20)
        }
        addressView.snp.makeConstraints { make in
            make.height.equalTo(centerNameView.snp.height)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(phoneNumberView.snp.bottom).offset(20)
        }
    }
    //MARK: - Action
    @objc
    private func showLocation() {
        viewModel?.tapNavigationRightButton()
    }
}
