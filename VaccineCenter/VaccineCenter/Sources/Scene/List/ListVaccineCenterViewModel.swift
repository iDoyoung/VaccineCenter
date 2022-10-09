//
//  ListVaccineCenterViewModel.swift
//  VaccineCenter
//
//  Created by Doyoung on 2022/10/09.
//

import Foundation
import RxSwift
import RxRelay

protocol ListVaccineCenterViewModelInput { }

protocol ListVaccineCenterViewModelOutput { }

final class ListVaccineCenterViewModel: ListVaccineCenterViewModelInput & ListVaccineCenterViewModelOutput {
    var service: NetworkDataTransferServiceProtocol?
    private var disposeBag = DisposeBag()
    var hasMorePages: Bool { 0 < (totalResultCount - (page*10)) }
    
    init() {
        guard let baseURL = URL(string: "https://api.odcloud.kr/api/15077586/v1/centers?") else {
            #if DEBUG
            print("URL is nil")
            #endif
            return
        }
        let networkAPI = NetworkAPIConfiguration(baseURL: baseURL, queryParameters: ["perPage": "10", "serviceKey": ""]) //TODO: - Setup serviceKey in Config
        let networkService = NetworkService(configuration: networkAPI)
        service = NetworkDataTransferService(networkService: networkService)
    }
    
    private func fetchVaccineCentersData(at page: String) -> Observable<VaccineCenterModel.Response> {
        return service!.reqeust(with: APIEndpoint.getVaccineCenter(page: page))
    }
        
    //MARK: - Input
    func fetchFirstPage() {
       fetchVaccineCentersData(at: String(page))
            .subscribe(onNext: { [weak self] response in
                self?.centers.accept(response.data)
                self?.totalResultCount = response.totalCount
            }, onError: { error in
                //TODO: - Setup Error Handler
            }).disposed(by: disposeBag)
    }
    
    func fetchNextPage() {
        page += 1
        if hasMorePages {
            fetchVaccineCentersData(at: String(page))
                .subscribe(onNext: { [weak self] response in
                    guard let self = self else { return }
                    var centers = self.centers.value
                    centers += response.data
                    self.centers.accept(centers)
                    self.totalResultCount = response.totalCount
                }, onError: { error in
                    //TODO: - Setup Error Handler
                }).disposed(by: disposeBag)
        }
    }
    
    //MARK: - Output
    var centers = BehaviorRelay<[VaccineCenterModel.Response.Center]>(value: [])
    var totalResultCount = 0
    var page = 1
    var vaccineCenter = [VaccineCenterModel.Response.Center]()
}
