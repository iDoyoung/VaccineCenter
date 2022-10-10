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
        tableView.register(VaccineCenterCell.self, forCellReuseIdentifier: VaccineCenterCell.reuseIdenetifier)
        return tableView
    }()
    lazy var scollToTopButton: UIButton = {
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
        configureUIComponents()
        guard let viewModel = viewModel else { return }
        viewModel.fetchFirstPage()
        bind(to: viewModel)
    }
    //MARK: - Configure
    private func configureUIComponents() {
        view.addSubview(vaccineCenterTableView)
        view.addSubview(scollToTopButton)
        vaccineCenterTableView.delegate = self
        setupLayoutConstraints()
    }
    private func bind(to viewModel: (ListVaccineCenterViewModelInput&ListVaccineCenterViewModelOutput)) {
        viewModel.centers.bind(to: vaccineCenterTableView.rx.items(cellIdentifier: VaccineCenterCell.reuseIdenetifier, cellType: VaccineCenterCell.self)) { index, item, cell in
            cell.setupContentLabelText(by: item)
        }
        .disposed(by: disposeBag)
    }
    //MARK: - Setup
    private func setupNavigationBar() {
        title = "예방접종센터 리스트"
    }
    private func setupLayoutConstraints() {
        vaccineCenterTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeArea.top)
            make.bottom.equalTo(view.safeArea.bottom)
        }
        scollToTopButton.snp.makeConstraints { make in
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
        let selected = viewModel.centers.value[indexPath.row]
        let destinationViewModel = DetailVaccineCenterViewModel(selected)
        let destination = DetailVaccineCenterViewController(viewModel: destinationViewModel)
        navigationController?.pushViewController(destination, animated: true)
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
