//
//  DetailVaccineCenterViewModel.swift
//  VaccineCenter
//
//  Created by Doyoung on 2022/10/10.
//

import Foundation
import RxSwift

protocol DetailVaccineCenterViewModelProtocol: DetailVaccineCenterViewModelInput & DetailVaccineCenterViewModelOutput { }

protocol DetailVaccineCenterViewModelInput {
    var selectedCenter: VaccineCenterModel.Response.Center { get }
    func tapNavigationRightButton()
}

protocol DetailVaccineCenterViewModelOutput {
    var centerName: Observable<String> { get }
    var buildingName: Observable<String> { get }
    var phoneNumber: Observable<String> { get }
    var updateTime: Observable<String> { get }
    var address: Observable<String> { get }
}

final class DetailVaccineCenterViewModel: DetailVaccineCenterViewModelProtocol {
    
    var segueToCenterLocation: (VaccineCenterModel.Response.Center) -> Void
    
    init(_ selectedCenter: VaccineCenterModel.Response.Center, segueToCurrentLocation: @escaping (VaccineCenterModel.Response.Center) -> Void) {
        self.selectedCenter = selectedCenter
        self.segueToCenterLocation = segueToCurrentLocation
        centerName = Observable.just(selectedCenter).map { $0.centerName }
        buildingName = Observable.just(selectedCenter).map { $0.facilityName }
        phoneNumber = Observable.just(selectedCenter).map { $0.phoneNumber }
        updateTime = Observable.just(selectedCenter).map { $0.updatedAt }
        address = Observable.just(selectedCenter).map { $0.address }
    }
    //MARK: - Input
    var selectedCenter: VaccineCenterModel.Response.Center
    
    func tapNavigationRightButton() {
        segueToCenterLocation(selectedCenter)
    }
    
    //MARK: - Output
    let centerName: Observable<String>
    let buildingName: Observable<String>
    let phoneNumber: Observable<String>
    let updateTime: Observable<String>
    let address: Observable<String>
}
