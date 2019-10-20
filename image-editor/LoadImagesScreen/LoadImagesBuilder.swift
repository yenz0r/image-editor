//
//  LoadImagesBuilder.swift
//  image-editor
//
//  Created by yenz0redd on 20.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol LoadImagesBuilder {
    func build(presetingView: UIViewController) -> LoadImagesCoordinator
}

class LoadImagesBuilderImpl: LoadImagesBuilder {
    func build(presetingView: UIViewController) -> LoadImagesCoordinator {
        let view = LoadImagesViewImpl()
        let coordinator = LoadImagesCoordinatorImpl(
            view: view,
            presentingVC: presetingView
        )
        let model = LoadImagesModelImpl()
        let presenter = LoadImagesPresenterImpl(
            model: model,
            view: view,
            coordinator: coordinator
        )
        view.presenter = presenter
        return coordinator
    }
}
