//
//  VaccineCenterModel.swift
//  VaccineCenter
//
//  Created by Doyoung on 2022/10/09.
//

import Foundation

enum VaccineCenterModel {
    struct Response: Decodable {
        let data: [Center]
        let totalCount: Int
        
        struct Center: Decodable {
            let id: Int
            let centerName: String
            let facilityName: String
            let address: String
            let phoneNumber: String
            let updatedAt: String
        }
    }
}
