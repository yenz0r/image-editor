//
//  StartCoordinator.swift
//  image-editor
//
//  Created by yenz0redd on 19.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol StartRouter: AnyObject {
    func start()
    func stop()
    func showLoadImagesScreen()
    func showCameraScreen()
    func showGallerySreen()
    func termiate()
}

final class StartCoordinator: NSObject {
    let window: UIWindow!
    let view: StartViewControllerImpl!

    var onTerminate: (() -> Void)?

    init(window: UIWindow,
         view: StartViewControllerImpl) {
        self.window = window
        self.view = view
    }
}

extension StartCoordinator: StartRouter {
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
        coordinator.onTerminate = {
            coordinator.stop { print("start module done") }
        }
        coordinator.start()
    }

    func showCameraScreen() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        self.view.present(imagePicker, animated: true, completion: nil)
    }

    func showGallerySreen() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.view.present(imagePicker, animated: true, completion: nil)
    }

    func showPreviewScreen(with image: UIImage?) {
        let builder = PreviewBuilderImpl()
        let coordinator = builder.build(with: image, presentingVC: self.view)
        coordinator.start()
    }
}

extension StartCoordinator: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        self.showPreviewScreen(with: pickedImage)
        self.view.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.view.dismiss(animated: true, completion: nil)
    }

    func termiate() {
        self.onTerminate?()
    }
}
