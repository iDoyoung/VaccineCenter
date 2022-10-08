//
//  DetailVaccineCenter.swift
//  VaccineCenter
//
//  Created by Doyoung on 2022/10/08.
//

import UIKit

final class DetailVaccineCenterViewController: UIViewController {
    //MARK: - Life Cycle
    override func loadView() {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    //MARK: - Setup
    private func setupNavigationBar() {
        title = ""
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "지도", style: .plain, target: self, action: #selector(showLocation))
    }
    //MARK: - Action
    @objc
    private func showLocation() {
    }
}
