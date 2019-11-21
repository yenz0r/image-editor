//
//  PreviewBuilder.swift
//  image-editor
//
//  Created by yenz0redd on 20.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol PreviewBuilder {
    func build(with image: UIImage?, presentingVC: UIViewController) -> PreviewCoordinator
}

final class PreviewBuilderImpl: PreviewBuilder {
    func build(with image: UIImage?, presentingVC: UIViewController) -> PreviewCoordinator {
        let view = PreviewViewImpl()
        let coordinator = PreviewCoordinator(
            view: view,
            presentingVC: presentingVC
        )
        let model = PreviewModelImpl()
        let presenter = PreviewPresenterImpl(
            model: model,
            view: view,
            coordinator: coordinator,
            image: image
        )
        view.presenter = presenter
        return coordinator
    }
}
