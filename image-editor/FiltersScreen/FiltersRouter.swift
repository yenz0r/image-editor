//
//  FiltersRouter.swift
//  image-editor
//
//  Created by yenz0redd on 30.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol FiltersRouter: AnyObject {
    func start()
    func showColorsScreen(with image: UIImage?)
    func startAnimation()
    func stopAnimation()
    func showErrorAlert()
}

final class FiltersCoordinator {
    let view: FiltersViewImpl
    let presentingVC: UIViewController

    init(view: FiltersViewImpl,
         presentingVC: UIViewController) {
        self.view = view
        self.presentingVC = presentingVC
    }
}

extension FiltersCoordinator: FiltersRouter {
    func showColorsScreen(with image: UIImage?) {
        let builder = ColorsBuilderImpl()
        let coordinator = builder.build(
            parentController: self.view,
            image: image
        )
        coordinator.onTerminate = {
            coordinator.stop { }
        }
        coordinator.start()
    }

    func start() {
        self.presentingVC.navigationController?.pushViewController(view, animated: true)
    }

    func startAnimation() {
        let alertController = UIAlertController(title: "Loading..", message: "Filter is in progress..", preferredStyle: .alert)
        self.view.present(alertController, animated: true, completion: nil)
    }

    func stopAnimation() {
        self.view.dismiss(animated: true, completion: nil)
    }

    func showErrorAlert() {
        let alertController = UIAlertController(title: "Error..", message: "Empty settings..", preferredStyle: .alert)
        self.view.present(alertController, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.view.dismiss(animated: true, completion: nil)
        }
    }
}
