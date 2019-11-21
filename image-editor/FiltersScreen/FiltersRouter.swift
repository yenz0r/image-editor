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
    func showLoadingAlert()
    func hideLoadingAlert()
    func showErrorAlert()
}

final class FiltersCoordinator {
    private var view: FiltersViewImpl?
    private let presentingVC: UIViewController

    init(view: FiltersViewImpl,
         presentingVC: UIViewController) {
        self.view = view
        self.presentingVC = presentingVC
    }
}

// MARK: - FiltersRouter implementation
extension FiltersCoordinator: FiltersRouter {
    func showColorsScreen(with image: UIImage?) {
        guard let view = view else { return }
        let builder = ColorsBuilderImpl()
        let coordinator = builder.build(
            parentController: view,
            image: image
        )
        coordinator.onTerminate = {
            coordinator.stop { }
        }
        coordinator.start()
    }

    func start() {
        guard let view = view else { return }
        self.presentingVC.navigationController?.pushViewController(view, animated: true)
    }

    func showLoadingAlert() {
        guard let view = view else { return }
        let alertController = UIAlertController(title: "Loading..", message: "Filter is in progress..", preferredStyle: .alert)
        view.present(alertController, animated: true, completion: nil)
    }

    func hideLoadingAlert() {
        guard let view = view else { return }
        view.dismiss(animated: true, completion: nil)
    }

    func showErrorAlert() {
        guard let view = view else { return }
        let alertController = UIAlertController(title: "Error..", message: "Empty settings..", preferredStyle: .alert)
        view.present(alertController, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            view.dismiss(animated: true, completion: nil)
        }
    }
}
