//
//  APIEndpoint.swift
//  VaccineCenter
//
//  Created by Doyoung on 2022/10/09.
//

import Foundation

struct APIEndpoint {
    static func getVaccineCenter(page: String) -> Endpoint<VaccineCenterModel.Response> {
        return Endpoint(path: "", method: .get, queryParameters: ["page": page])
    }
}
