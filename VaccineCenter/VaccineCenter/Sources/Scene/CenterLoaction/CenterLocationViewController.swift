//
//  CenterLocationViewController.swift
//  VaccineCenter
//
//  Created by Doyoung on 2022/10/10.
//

import UIKit
import MapKit
import SnapKit
import RxSwift

final class CenterLocationViewController: UIViewController {
    
    var viewModel: CenterLocationViewModelOutput?
    private var disposeBag = DisposeBag()
    private let locationManager = CLLocationManager()
    private let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    private var currentLocation: CLLocation?
    private var vaccineCenterLocation: CLLocationCoordinate2D?
    //MARK: - UI Components
    private let mapView = MKMapView()
    private lazy var showCurrentLocationButton: UIButton = {
        let button = UIButton()
        button.setTitle("현재위치로", for: .normal)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(showCurrentLocation), for: .touchUpInside)
        button.rounded(5)
        return button
    }()
    
    private lazy var showVaccineCenterLocationButton: UIButton = {
        let button = UIButton()
        button.setTitle("접종센터로", for: .normal)
        button.backgroundColor = .systemRed
        button.addTarget(self, action: #selector(showVaccineCenterLocation), for: .touchUpInside)
        button.rounded(5)
        return button
    }()
    
    //MARK: - Life Cycle
    override func loadView() {
        view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIComponents()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        guard let viewModel = viewModel else {  return  }
        bind(to: viewModel)
    }
    
    //MARK: - Configure
    private func configureUIComponents() {
        view.addSubview(showCurrentLocationButton)
        view.addSubview(showVaccineCenterLocationButton)
        setupLayoutConstraints()
        setupNavigationBar()
    }
    
    private func bind(to viewModel: CenterLocationViewModelOutput) {
        viewModel.centerLocation.subscribe { [weak self] location in
            guard let self = self else { return }
            let latitude = CLLocationDegrees(location["latitude"] ?? 0)
            let longitude = CLLocationDegrees(location["longitude"] ?? 0)
            self.vaccineCenterLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            guard let coordinate = self.vaccineCenterLocation else { return }
            self.markVaccineCenterAnnotation(coordinate: coordinate)
        } onError: { error in
            #if DEBUG
            print("Binding Error: \(error)")
            #endif
        }.disposed(by: disposeBag)
    }
    
    //MARK: - Setup Layout Const
    private func setupNavigationBar() {
        title = "지도"
    }
    
    private func setupLayoutConstraints() {
        mapView.delegate = self
        showCurrentLocationButton.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(showVaccineCenterLocationButton.snp.top).offset(-8)
        }
        showVaccineCenterLocationButton.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalTo(view.safeArea.bottom).offset(-40)
        }
    }
    
    //MARK: Actions
    @objc
    private func showCurrentLocation() {
        guard let currentLocation = currentLocation else {
            return
        }
        let coordinate = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude,
                                               longitude: currentLocation.coordinate.longitude)
        mapView.setRegion(MKCoordinateRegion(center: coordinate, span: span), animated: true)
    }
    
    @objc
    private func showVaccineCenterLocation() {
        guard let vaccineCenterLocation = vaccineCenterLocation else { return }
        mapView.setRegion(MKCoordinateRegion(center: vaccineCenterLocation, span: span), animated: true)
    }
}

extension CenterLocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            currentLocation = location
            mapView.showsUserLocation = true
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}

extension CenterLocationViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let vaccineCenterAnnotation = mapView.dequeueReusableAnnotationView(withIdentifier: VaccineCenterAnnotation.reuseIdentifier)
        return vaccineCenterAnnotation
    }
}
//MARK: - Mark Annotation
extension CenterLocationViewController {
    private func markVaccineCenterAnnotation(coordinate: CLLocationCoordinate2D) {
        let annotation = VaccineCenterAnnotation(coordinate: coordinate)
        mapView.addAnnotation(annotation)
        showVaccineCenterLocation()
    }
}
