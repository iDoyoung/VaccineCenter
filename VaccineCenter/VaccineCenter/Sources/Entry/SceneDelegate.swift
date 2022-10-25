//
//  SceneDelegate.swift
//  VaccineCenter
//
//  Created by Doyoung on 2022/10/07.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: VaccineCenterCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let initialViewController = UINavigationController()
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        window?.rootViewController = initialViewController
        coordinator = VaccineCenterCoordinator(navigationController: initialViewController, dependencies: VaccineCentersSceneDIContainer())
        coordinator?.start()
        window?.makeKeyAndVisible()
    }
}

