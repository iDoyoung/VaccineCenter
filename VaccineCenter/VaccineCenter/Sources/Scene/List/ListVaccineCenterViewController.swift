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
    private var disposeBag = DisposeBag()
    var viewModel: (ListVaccineCenterViewModelInput & ListVaccineCenterViewModelOutput)?
    //MARK: - UI Components
    let vaccineCenterTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    //MARK: - Life Cycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.viewModel = ListVaccineCenterViewModel()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemBackground
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        configureVaccineCenterTableView()
        guard let viewModel = viewModel else { return }
        viewModel.fetchFirstPage()
        bind(to: viewModel)
    }
    //MARK: - Configure
    private func configureVaccineCenterTableView() {
        view.addSubview(vaccineCenterTableView)
        setupVaccineCenterTableViewLayoutConstraints()
    }
    private func bind(to viewModel: (ListVaccineCenterViewModelInput&ListVaccineCenterViewModelOutput)) {
        viewModel.centers.bind(to: vaccineCenterTableView.rx.items(cellIdentifier: VaccineCenterCell.reuseIdenetifier, cellType: VaccineCenterCell.self)) { index, center, cell in
            cell.vaccineCenter = center
        }
        .disposed(by: disposeBag)
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
