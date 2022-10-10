//
//  VaccineCenterAnnotation.swift
//  VaccineCenter
//
//  Created by Doyoung on 2022/10/10.
//

import UIKit
import MapKit

final class VaccineCenterAnnotation: NSObject, MKAnnotation {
    static let reuseIdentifier = "VaccineCenterAnnotationReuseIdentifier"
    var coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
}
