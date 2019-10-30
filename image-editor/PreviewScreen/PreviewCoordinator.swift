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
        let filtersView = FiltersViewImpl()
        filtersView.modalPresentationStyle = .fullScreen
        self.view.navigationController?.pushViewController(filtersView, animated: true)
    }

    func start() {
        self.presentingVC.navigationController?.pushViewController(view, animated: true)
    }
}
