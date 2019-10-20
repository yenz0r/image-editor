//
//  PreviewCoordinator.swift
//  image-editor
//
//  Created by yenz0redd on 20.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol PreviewCoordinator {
    func start()
    func showEditScreen(with image: UIImage?)
}

class PreviewCoordinatorImpl: PreviewCoordinator {
    let view: PreviewViewImpl
    let presentingVC: UIViewController

    init(view: PreviewViewImpl,
         presentingVC: UIViewController) {
        self.view = view
        self.presentingVC = presentingVC
    }

    func showEditScreen(with image: UIImage?) {
        print("edit")
    }

    func start() {
        self.presentingVC.navigationController?.pushViewController(view, animated: true)
    }
}
