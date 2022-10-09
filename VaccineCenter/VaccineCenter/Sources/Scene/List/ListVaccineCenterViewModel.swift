//
//  ListVaccineCenterViewModel.swift
//  VaccineCenter
//
//  Created by Doyoung on 2022/10/09.
//

import Foundation
import RxSwift

protocol ListVaccineCenterViewModelInput { }

protocol ListVaccineCenterViewModelOutput { }

final class ListVaccineCenterViewModel: ListVaccineCenterViewModelInput & ListVaccineCenterViewModelOutput {
    var service: NetworkDataTransferServiceProtocol?
    
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
        
    //MARK: - Input
    func loadFirst() { }
    func scrollDown() { }
    
    //MARK: - Output
    var totalResultCount: Int?
    var page = 1
    var vaccineCenter = [VaccineCenterModel.Response.Center]()
}
