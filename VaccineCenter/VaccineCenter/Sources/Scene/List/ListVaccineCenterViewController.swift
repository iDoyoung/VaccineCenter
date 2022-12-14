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
    var viewModel: ListVaccineCenterViewModelProtocol?
    //MARK: - UI Components
    private let vaccineCenterTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(VaccineCenterCell.self, forCellReuseIdentifier: VaccineCenterCell.reuseIdentifier)
        return tableView
    }()
    private lazy var scrollToTopButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBackground
        button.addTarget(self, action: #selector(scrollToTop), for: .touchUpInside)
        button.setImage(UIImage(named: "top-alignment"), for: .normal)
        button.tintColor = .label
        button.rounded(25)
        button.shadow()
        return button
    }()
    //MARK: - Life Cycle
    override func loadView() {
        view = UIView()
        view.backgroundColor = .systemBackground
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        configureUIComponents()
        guard let viewModel = viewModel else { return }
        viewModel.fetchFirstPage()
        bind(to: viewModel)
    }
    //MARK: - Configure
    private func configureUIComponents() {
        view.addSubview(vaccineCenterTableView)
        view.addSubview(scrollToTopButton)
        vaccineCenterTableView.delegate = self
        setupLayoutConstraints()
    }
    private func bind(to viewModel: (ListVaccineCenterViewModelInput&ListVaccineCenterViewModelOutput)) {
        viewModel.centers
            .map { centers in centers.sorted(by: {$0.updatedAt > $1.updatedAt}) }
            .bind(to: vaccineCenterTableView.rx.items(cellIdentifier: VaccineCenterCell.reuseIdentifier, cellType: VaccineCenterCell.self)) { index, item, cell in
            cell.setupContentLabelText(by: item)
        }
        .disposed(by: disposeBag)
        viewModel.fetchingError
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] error in
                guard let error = error else { return }
                switch error {
                case .networkFailure(let error):
                    switch error {
                    case .notConnectedInternet:
                        self?.internetConnectErrorAlert()
                    case .timeOut:
                        self?.timeOutErrorAlert()
                    default:
                        self?.serverErrorAlert()
                    }
                default:
                    self?.programErrorAlert()
                }
            }).disposed(by: disposeBag)
    }
    //MARK: - Setup
    private func setupNavigationBar() {
        title = "?????????????????? ?????????"
    }
    private func setupLayoutConstraints() {
        vaccineCenterTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeArea.top)
            make.bottom.equalTo(view.safeArea.bottom)
        }
        scrollToTopButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(50)
            make.bottom.equalTo(view.safeArea.bottom).offset(-40)
            make.trailing.equalTo(view.safeArea.trailing).offset(-40)
        }
    }
    //MARK: - Action
    @objc
    private func scrollToTop() {
        let indexPath = IndexPath(row: 0, section: 0)
        vaccineCenterTableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}

extension ListVaccineCenterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let viewModel = viewModel else { return }
        viewModel.didSelectItem(at: indexPath.row)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if vaccineCenterTableView.contentOffset.y > vaccineCenterTableView.contentSize.height - vaccineCenterTableView.bounds.size.height {
            guard let viewModel = viewModel else { return }
            if !viewModel.isLoading {
                viewModel.fetchNextPage()
            }
        }
    }
}

//MARK: - Error Alert
extension ListVaccineCenterViewController {
    private func programErrorAlert() {
        present(configureAlert("???????????? ??????"), animated: true)
    }
    private func timeOutErrorAlert() {
        present(configureAlert("?????? ????????? ?????????????????????."), animated: true)
    }
    private func internetConnectErrorAlert() {
        present(configureAlert("???????????? ???????????? ?????? ????????????."), animated: true)
    }
    private func serverErrorAlert() {
        present(configureAlert("???????????????. ?????? ?????? ?????? ????????????."), animated: true)
    }
    private func configureAlert(_ title: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "??????", style: .cancel)
        alert.addAction(action)
        return alert
    }
}
