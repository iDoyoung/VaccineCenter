//
//  DetailVaccineCenterViewModel.swift
//  VaccineCenter
//
//  Created by Doyoung on 2022/10/10.
//

import Foundation
import RxSwift

protocol DetailVaccineCenterOutput {
    var centerName: Observable<String> { get }
    var buildingName: Observable<String> { get }
    var phoneNumber: Observable<String> { get }
    var updateTime: Observable<String> { get }
    var address: Observable<String> { get }
}
final class DetailVaccineCenterViewModel: DetailVaccineCenterOutput {
    init(_ selectedCenter: VaccineCenterModel.Response.Center) {
        let center = Observable.just(selectedCenter)
        centerName = center.map { $0.centerName }
        buildingName = center.map { $0.facilityName }
        phoneNumber = center.map { $0.phoneNumber }
        updateTime = center.map { $0.updatedAt }
        address = center.map { $0.address }
    }
    //MARK: - Output
    let centerName: Observable<String>
    let buildingName: Observable<String>
    let phoneNumber: Observable<String>
    let updateTime: Observable<String>
    let address: Observable<String>
}
