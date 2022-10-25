//
//  CenterLocationViewModel.swift
//  VaccineCenter
//
//  Created by Doyoung on 2022/10/10.
//

import Foundation
import RxSwift

protocol CenterLocationViewModelProtocol: CenterLocationViewModelInput, CenterLocationViewModelOutput { }

protocol CenterLocationViewModelInput {
    var selectedCenter: VaccineCenterModel.Response.Center { get }
}
protocol CenterLocationViewModelOutput {
    var centerLocation: Observable<[String: Float]> { get }
}

final class CenterLocationViewModel: CenterLocationViewModelProtocol {
    init(_ selectedCenter: VaccineCenterModel.Response.Center) {
        self.selectedCenter = selectedCenter
        centerLocation = Observable
            .just(selectedCenter)
            .map { ["latitude": Float($0.lat) ?? 0, "longitude": Float($0.lng) ?? 0]}
    }
    //MARK: - Input
    var selectedCenter: VaccineCenterModel.Response.Center
    //MARK: - Output
    let centerLocation: Observable<[String: Float]>
}
