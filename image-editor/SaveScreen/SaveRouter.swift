//
//  SaveRouter.swift
//  image-editor
//
//  Created by yenz0redd on 30.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol SaveRouter: AnyObject {
    func start()
    func stop(completion: @escaping () -> Void)
    func terminate()
    func saveImage(image: UIImage?)
    func showStartScreen()
}

final class SaveCoordinator {
    private var view: SaveViewImpl?
    private let parentController: UIViewController

    var onTerminate: (() -> Void)?

    init(view: SaveViewImpl,
         parentController: UIViewController) {
        self.view = view
        self.parentController = parentController
    }
}

extension SaveCoordinator: SaveRouter {
    func showStartScreen() {
        self.view?.navigationController?.popToRootViewController(animated: true)
    }

    func start() {
        guard let view = view else { return }
        self.parentController.navigationController?.pushViewController(view, animated: true)
    }

    func stop(completion: @escaping () -> Void) {
        self.view = nil
        completion()
    }

    func terminate() {
        self.onTerminate?()
    }

    func saveImage(image: UIImage?) {
        guard let image = image else { return }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        self.showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
    }

    private func showAlertWith(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.view?.dismiss(animated: true, completion: nil)
        }
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            self.view?.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.view?.present(alertController, animated: true, completion: nil)
    }
}
