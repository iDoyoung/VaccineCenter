//
//  ViewController.swift
//  VaccineCenter
//
//  Created by Doyoung on 2022/10/07.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ListVaccineCenterViewController: UIViewController {
    //MARK: - UI Components
    let vaccineCenterTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    //MARK: - Life Cycle
    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemBackground
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        configureVaccineCenterTableView()
    }
    //MARK: - Configure
    private func configureVaccineCenterTableView() {
        view.addSubview(vaccineCenterTableView)
        setupVaccineCenterTableViewLayoutConstraints()
    }
    //MARK: - Setup
    private func setupNavigationBar() {
        title = "예방접종센터 리스트"
    }
    private func setupVaccineCenterTableViewLayoutConstraints() {
        vaccineCenterTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeArea.top)
            make.bottom.equalTo(view.safeArea.bottom)
        }
    }
}
