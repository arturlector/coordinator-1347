//
//  Coordinator.swift
//  coordinator-1347
//
//  Created by Artur Igberdin on 12.11.2021.
//

import UIKit
import Combine
import SwiftUI

class MainCoordinator {
    
    let navigationController: UINavigationController
    private let loginViewModel: LoginViewModel = LoginViewModel()
    private let coreDataService: CoreDataService = CoreDataService(modelName: "City")
    private var cancellables: Set<AnyCancellable> = []
    
    init(navigationController: UINavigationController) {
        let loginView = LoginView(viewModel: loginViewModel)
        let loginViewController = UIHostingController(rootView: loginView)
        self.navigationController = UINavigationController(rootViewController: loginViewController)
    }
    
    public func start() {
        loginViewModel.$isUserLoggedIn.subscribe(on: RunLoop.main).sink { [weak self] isUserLoggedIn in
            guard let self = self else { return }
            if !isUserLoggedIn {
                self.navigationController.popToRootViewController(animated: true)
            } else {
                let citiesViewController = self.createCitiesController()
                self.navigationController.pushViewController(citiesViewController, animated: true)
            }
        }.store(in: &cancellables)
    }
    
    private func createCitiesController() -> UIViewController {
        let context = coreDataService.context
        let citiesView = CitiesView().environment(\.managedObjectContext, context)
        return UIHostingController(rootView: citiesView)
    }
}
