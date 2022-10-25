//
//  VaccineCentersSceneDIContainer.swift
//  VaccineCenter
//
//  Created by Doyoung on 2022/10/15.
//

import UIKit

final class VaccineCentersSceneDIContainer: VaccineCenterCoordinatorDependenciesProtocol {
    
    //MARK: - Service
    func makeNetworkService() throws -> NetworkDataTransferServiceProtocol {
        guard let baseURL = URL(string: "https://api.odcloud.kr/api/15077586/v1/centers?") else {
            #if DEBUG
            print("URL is nil")
            #endif
            throw NetworkError.badURL
        }
        let networkAPI = NetworkAPIConfiguration(baseURL: baseURL, headers: [ConfidentialKey.authServiceKey.key: ConfidentialKey.authServiceKey.value], queryParameters: ["perPage": "10"])
        let networkService = NetworkService(configuration: networkAPI)
        return NetworkDataTransferService(networkService: networkService)
    }
    //MARK: - Vaccine Center List
    func makeListVaccineCenterViewController(segue: @escaping SegueToDetail) -> ListVaccineCenterViewController {
        let view = ListVaccineCenterViewController()
        let viewModel = makeListVaccineCenterViewModel(segue: segue)
        view.viewModel = viewModel
        return view
    }
    
    func makeListVaccineCenterViewModel(segue: @escaping SegueToDetail) -> ListVaccineCenterViewModelProtocol {
        let viewModel = ListVaccineCenterViewModel(segueToDetail: segue)
        viewModel.service = try? makeNetworkService()
        return viewModel
    }
  
    //MARK: - Vaccine Center Detail
    func makeDetailVaccineCenterViewController(center: VaccineCenterModel.Response.Center, segue: @escaping SegueToCenterLoaction) -> UIViewController {
        let view = DetailVaccineCenterViewController()
        view.viewModel = makeDetailVaccineCenterViewModel(by: center, segue: segue)
        return view
    }
    
    func makeDetailVaccineCenterViewModel(by model: VaccineCenterModel.Response.Center, segue: @escaping SegueToCenterLoaction) -> DetailVaccineCenterViewModelProtocol {
        let viewModel = DetailVaccineCenterViewModel(model, segueToCurrentLocation: segue)
        return viewModel
    }
    
    //MARK: - Vaccine Center Loaction
    func makeCenterLocationViewController(center: VaccineCenterModel.Response.Center) -> UIViewController {
        let view = CenterLocationViewController()
        view.viewModel = makeCenterLocationViewModel(by: center)
        return view
    }
    
    func makeCenterLocationViewModel(by model: VaccineCenterModel.Response.Center) -> CenterLocationViewModel {
        let viewModel = CenterLocationViewModel(model)
        return viewModel
    }
}
