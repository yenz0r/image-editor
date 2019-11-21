//
//  PreviewCoordinator.swift
//  image-editor
//
//  Created by yenz0redd on 20.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol PreviewRouter: AnyObject {
    func showEditScreen(with image: UIImage?)
    func showColorsScreen(with image: UIImage?)
}

final class PreviewCoordinator {
    private var view: PreviewViewImpl?
    private let presentingVC: UIViewController

    var onTerminate: (() -> Void)?

    init(view: PreviewViewImpl,
         presentingVC: UIViewController) {
        self.view = view
        self.presentingVC = presentingVC
    }
}

// MARK: - PreviewRouter implementation
extension PreviewCoordinator: PreviewRouter {
    func showEditScreen(with image: UIImage?) {
        guard let view = view else { return }
        let builder = FiltersBuilderImpl()
        let coordinator = builder.build(with: image, presentingVC: view)
        coordinator.start()
    }

    func showColorsScreen(with image: UIImage?) {
        guard let view = view else { return }
        let builder = ColorsBuilderImpl()
        let coordinator = builder.build(parentController: view, image: image)
        coordinator.onTerminate = {
            coordinator.stop { }
        }
        coordinator.start()
    }


    func start() {
        guard let view = view else { return }
        self.presentingVC.navigationController?.pushViewController(view, animated: true)
    }

    func stop(completion: @escaping () -> Void) {
        self.view = nil
        self.presentingVC.navigationController?.popViewController(animated: true)
        completion()
    }
}
