//
//  VaccineCenterCoordinator.swift
//  VaccineCenter
//
//  Created by Doyoung on 2022/10/15.
//

import UIKit

protocol VaccineCenterCoordinatorDependenciesProtocol {
    
    typealias SegueToDetail = (VaccineCenterModel.Response.Center) -> Void
    typealias SegueToCenterLoaction = (VaccineCenterModel.Response.Center) -> Void
    
    func makeListVaccineCenterViewController(segue: @escaping SegueToDetail) -> ListVaccineCenterViewController
    func makeDetailVaccineCenterViewController(center: VaccineCenterModel.Response.Center, segue: @escaping SegueToCenterLoaction) -> UIViewController
    func makeCenterLocationViewController(center: VaccineCenterModel.Response.Center) -> UIViewController
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
        let viewController = dependencies.makeListVaccineCenterViewController(segue: showDetailVaccineCenter)
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    private func showDetailVaccineCenter(center: VaccineCenterModel.Response.Center) {
        let viewController = dependencies.makeDetailVaccineCenterViewController(center: center, segue: showCenterLoaction)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func showCenterLoaction(center: VaccineCenterModel.Response.Center) {
        let viewController = dependencies.makeCenterLocationViewController(center: center)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
