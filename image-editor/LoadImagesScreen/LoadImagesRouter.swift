//
//  LoadImagesCoordinator.swift
//  image-editor
//
//  Created by yenz0redd on 20.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol LoadImagesRouter: AnyObject {
    func showPreviewScreen(with image: UIImage?)
    func terminate()
}

final class LoadImagesCoordinator {
    private var view: LoadImagesViewImpl?
    private let presentingVC: UIViewController

    var onTerminate: (() -> Void)?

    init(view: LoadImagesViewImpl,
         presentingVC: UIViewController) {
        self.view = view
        self.presentingVC = presentingVC
    }
}

// MARK: - LoadImagesRouter implementation
extension LoadImagesCoordinator: LoadImagesRouter {
    func showPreviewScreen(with image: UIImage?) {
        guard let view = view else { return }
        let builder = PreviewBuilderImpl()
        let coordinator = builder.build(with: image, presentingVC: view)
        coordinator.onTerminate = {
            coordinator.stop { }
        }
        coordinator.start()
    }

    func start() {
        guard let view = self.view else { return }
        self.presentingVC.navigationController?.pushViewController(view, animated: true)
    }

    func stop(completion: @escaping () -> ()) {
        self.view = nil
        self.presentingVC.dismiss(animated: true, completion: completion)
    }

    func terminate() {
        self.onTerminate?()
    }
}
