//
//  LoadImagesCoordinator.swift
//  image-editor
//
//  Created by yenz0redd on 20.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol LoadImagesCoordinator {
    func start()
    func showPreviewScreen(with image: UIImage?)
}

class LoadImagesCoordinatorImpl: LoadImagesCoordinator {
    let view: LoadImagesViewImpl
    let presentingVC: UIViewController

    init(view: LoadImagesViewImpl,
         presentingVC: UIViewController) {
        self.view = view
        self.presentingVC = presentingVC
    }

    func showPreviewScreen(with image: UIImage?) {
        let builder = PreviewBuilderImpl()
        let coordinator = builder.build(with: image, presentingVC: self.view)
        coordinator.start()
    }

    func start() {
        self.presentingVC.navigationController?.pushViewController(self.view, animated: true)
    }
}
