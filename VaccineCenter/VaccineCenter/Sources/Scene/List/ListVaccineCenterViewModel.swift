//
//  ListVaccineCenterViewModel.swift
//  VaccineCenter
//
//  Created by Doyoung on 2022/10/09.
//

import Foundation
import RxSwift
import RxRelay

protocol ListVaccineCenterViewModelProtocol: ListVaccineCenterViewModelInput, ListVaccineCenterViewModelOutput { }

protocol ListVaccineCenterViewModelInput {
    var isLoading: Bool { get }
    func fetchFirstPage()
    func fetchNextPage()
    func didSelectItem(at index: Int)
}

protocol ListVaccineCenterViewModelOutput {
    var fetchingError: BehaviorSubject<DataTransferError?> { get }
    var centers: BehaviorRelay<[VaccineCenterModel.Response.Center]> { get }
}

final class ListVaccineCenterViewModel: ListVaccineCenterViewModelProtocol {
    var service: NetworkDataTransferServiceProtocol?
    var segueToDetail: ((VaccineCenterModel.Response.Center) -> Void)
    private var disposeBag = DisposeBag()
    private var hasMorePages: Bool { 0 < (totalResultCount - (page*10)) }
    var isLoading = false
    
    private func fetchVaccineCentersData(at page: String) -> Observable<VaccineCenterModel.Response> {
        guard let service = service else {
            return Observable.error(NetworkError.badURL)
        }
        return service.request(with: APIEndpoint.getVaccineCenter(page: page))
    }
    
    init(segueToDetail: @escaping (VaccineCenterModel.Response.Center) -> Void) {
        self.segueToDetail = segueToDetail
    }
    
    //MARK: - Input
    func fetchFirstPage() {
        isLoading = true
        fetchVaccineCentersData(at: String(page))
            .subscribe(onNext: { [weak self] response in
                self?.centers.accept(response.data)
                self?.totalResultCount = response.totalCount
                self?.isLoading = false
            }, onError: { [weak self] error in
                self?.fetchingError.onNext(error as? DataTransferError)
                self?.isLoading = false
            }).disposed(by: disposeBag)
    }
    
    func fetchNextPage() {
        if hasMorePages {
            page += 1
            fetchVaccineCentersData(at: String(page))
                .subscribe(onNext: { [weak self] response in
                    guard let self = self else { return }
                    var centers = self.centers.value
                    centers += response.data
                    self.centers.accept(centers)
                    self.totalResultCount = response.totalCount
                    self.isLoading = false
                }, onError: { [weak self] error in
                    //TODO: - Setup Error Handler
                    self?.isLoading = false
                }).disposed(by: disposeBag)
        }
    }
    
    func didSelectItem(at index: Int) {
        segueToDetail(centers.value[index])
    }
    //MARK: - Output
    var fetchingError = BehaviorSubject<DataTransferError?>(value: nil)
    var centers = BehaviorRelay<[VaccineCenterModel.Response.Center]>(value: [])
    private var totalResultCount = 0
    private var page = 1
}
