//
//  StartCoordinator.swift
//  image-editor
//
//  Created by yenz0redd on 19.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol StartRouter: AnyObject {
    func showLoadImagesScreen()
    func showCameraScreen()
    func showGallerySreen()
    func termiate()
}

final class StartCoordinator: NSObject {
    private let window: UIWindow
    private var view: StartViewImpl?

    var onTerminate: (() -> Void)?

    init(window: UIWindow,
         view: StartViewImpl) {
        self.window = window
        self.view = view
    }
}

extension StartCoordinator: StartRouter {
    func start() {
        guard let view = view else { return }
        let navController = UINavigationController(rootViewController: view)
        self.window.rootViewController = navController
        self.window.makeKeyAndVisible()
    }

    func stop(completion: @escaping () -> Void) {
        self.view = nil
        self.window.isHidden = true
        completion()
    }

    func showLoadImagesScreen() {
        guard let view = view else { return }
        let coordinator = LoadImagesBuilderImpl().build(presetingView: view)
        coordinator.onTerminate = {
            coordinator.stop { print("start module done") }
        }
        coordinator.start()
    }

    func showCameraScreen() {
        guard let view = view else { return }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        view.present(imagePicker, animated: true, completion: nil)
    }

    func showGallerySreen() {
        guard let view = view else { return }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        view.present(imagePicker, animated: true, completion: nil)
    }

    func showPreviewScreen(with image: UIImage?) {
        guard let view = view else { return }
        let builder = PreviewBuilderImpl()
        let coordinator = builder.build(with: image, presentingVC: view)
        coordinator.onTerminate = {
            coordinator.stop { }
        }
        coordinator.start()
    }
}

extension StartCoordinator: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let view = view else { return }
        guard let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        self.showPreviewScreen(with: pickedImage)
        view.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        guard let view = view else { return }
        view.dismiss(animated: true, completion: nil)
    }

    func termiate() {
        self.onTerminate?()
    }
}
