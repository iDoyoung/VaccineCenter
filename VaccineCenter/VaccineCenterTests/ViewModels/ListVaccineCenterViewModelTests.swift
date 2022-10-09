//
//  ListVaccineCenterViewModelTests.swift
//  VaccineCenterTests
//
//  Created by Doyoung on 2022/10/09.
//

import XCTest
@testable import VaccineCenter

class ListVaccineCenterViewModelTests: XCTestCase {
    //MARK: - System Under Tests
    var sut: ListVaccineCenterViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = ListVaccineCenterViewModel()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
}
