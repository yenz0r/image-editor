//
//  PreviewCoordinator.swift
//  image-editor
//
//  Created by yenz0redd on 20.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol PreviewRouter: AnyObject {
    func start()
    func showEditScreen(with image: UIImage?)
}

final class PreviewCoordinator {
    let view: PreviewViewImpl
    let presentingVC: UIViewController

    init(view: PreviewViewImpl,
         presentingVC: UIViewController) {
        self.view = view
        self.presentingVC = presentingVC
    }
}

extension PreviewCoordinator: PreviewRouter {
    func showEditScreen(with image: UIImage?) {
           let builder = FiltersBuilderImpl()
           let coordinator = builder.build(with: image, presentingVC: self.view)
           coordinator.start()
       }

       func start() {
           self.presentingVC.navigationController?.pushViewController(view, animated: true)
       }
}
