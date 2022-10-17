//
//  VaccineCentersSceneDIContainer.swift
//  VaccineCenter
//
//  Created by Doyoung on 2022/10/15.
//

import UIKit

final class VaccineCentersSceneDIContainer: VaccineCenterCoordinatorDependenciesProtocol {
    
    struct Dependencies {
        let networkService: NetworkDataTransferServiceProtocol
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    //MARK: - Service
    func makeNetworkService() -> NetworkDataTransferServiceProtocol {
        guard let baseURL = URL(string: "https://api.odcloud.kr/api/15077586/v1/centers?") else {
            #if DEBUG
            print("URL is nil")
            #endif
            return
        }
        let networkAPI = NetworkAPIConfiguration(baseURL: baseURL, headers: [ConfidentialKey.authServiceKey.key: ConfidentialKey.authServiceKey.value], queryParameters: ["perPage": "10"])
        let networkService = NetworkService(configuration: networkAPI)
        return NetworkDataTransferService(networkService: networkService)
    }
    //MARK: - List
    func makeListVaccineCenterViewController() -> ListVaccineCenterViewController {
        let view = ListVaccineCenterViewController()
        return view
    }
    
    func makeListVaccineCenterViewModel() -> ListVaccineCenterViewModel {
        return ListVaccineCenterViewModel()
    }
    
    func makeVaccineCenterListViewModel() -> ListVaccineCenterViewModel {
    }
    func makeDetailVaccineCenterViewController() -> UIViewController {
    }
    func makeDetailVaccineCenterViewModel() -> DetailVaccineCenterViewModel {
    }
    func makeCenterLocationViewController() -> UIViewController {
    }
    func makeCenterLocationViewController() -> CenterLocationViewModel {
    }
}
