//
//  ColorsRouter.swift
//  image-editor
//
//  Created by yenz0redd on 30.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol ColorsRouter {
    func start()
    func stop(completion: @escaping () -> Void)
    func terminate()
    func showSaveScreen(with image: UIImage?)
}

class ColorsCoordinator {
    private let parentController: UIViewController
    private var view: ColorsViewImpl?

    var onTerminate: (() -> ())?

    init(parentController: UIViewController,
         view: ColorsViewImpl) {
        self.parentController = parentController
        self.view = view
    }
}

extension ColorsCoordinator: ColorsRouter {
    func start() {
        guard let view = view else {
            return
        }
        self.parentController.navigationController?.pushViewController(view, animated: true)
    }

    func stop(completion: @escaping () -> Void) {
        self.parentController.navigationController?.popViewController(animated: true)
        self.view = nil
        completion()
    }

    func terminate() {
        self.onTerminate?()
    }

    func showSaveScreen(with image: UIImage?) {
        let builder = SaveBuilderImpl()
        let coordinator = builder.build(
            parentController: self.parentController,
            image: image
        )
        coordinator.onTerminate = {
            coordinator.stop { }
        }
        coordinator.start()
    }
}
