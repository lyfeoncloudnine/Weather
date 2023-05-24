//
//  AppDelegate.swift
//  Weather
//
//  Created by lyfeoncloudnine on 2023/05/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setRootViewController()
        return true
    }
}

private extension AppDelegate {
    func setRootViewController() {
        let viewController = ListViewController()
        let networkService = NetworkService()
        viewController.reactor = ListViewReactor(networkService: networkService)
        let navigationController = UINavigationController(rootViewController: viewController)
        
        let initialWindow = UIWindow(frame: UIScreen.main.bounds)
        initialWindow.rootViewController = navigationController
        initialWindow.makeKeyAndVisible()
        
        window = initialWindow
    }
}
