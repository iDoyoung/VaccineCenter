//
//  VaccineCenterCoordinator.swift
//  VaccineCenter
//
//  Created by Doyoung on 2022/10/15.
//

import UIKit

protocol VaccineCenterCoordinatorDependenciesProtocol {
    func makeVaccineCenterListViewController() -> ListVaccineCenterViewController
    func makeDetailVaccineCenterViewController() -> UIViewController
    func makeCenterLocationViewController() -> UIViewController
}

final class VaccineCenterCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: VaccineCenterCoordinatorDependenciesProtocol
    
    init(navigationController: UINavigationController,
         dependencies: VaccineCenterCoordinatorDependenciesProtocol) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let viewController = dependencies.makeVaccineCenterListViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showDetailVaccineCenter() {
        let viewController = dependencies.makeDetailVaccineCenterViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    private func showCenterLoaction() {
        let viewController = dependencies.makeCenterLocationViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
}
