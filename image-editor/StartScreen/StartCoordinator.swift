//
//  StartCoordinator.swift
//  image-editor
//
//  Created by yenz0redd on 19.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol StartCoordinator {
    func start()
    func stop()
    func showLoadImagesScreen()
    var onTerminate: (() -> Void)? { get set }
}

class StartCoordinatorImpl: StartCoordinator {
    let window: UIWindow!
    let view: StartViewControllerImpl!

    init(window: UIWindow,
         view: StartViewControllerImpl) {
        self.window = window
        self.view = view
    }

    var onTerminate: (() -> Void)?

    func start() {
        let navController = UINavigationController(rootViewController: self.view)
        self.window.rootViewController = navController
        self.window.makeKeyAndVisible()
    }

    func stop() {
        self.onTerminate?()
    }

    func showLoadImagesScreen() {
        let coordinator = LoadImagesBuilderImpl().build(presetingView: view)
        coordinator.start()
    }
}
