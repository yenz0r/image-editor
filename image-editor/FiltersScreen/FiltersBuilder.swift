//
//  FiltersBuilder.swift
//  image-editor
//
//  Created by yenz0redd on 30.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol FiltersBuilder {
    func build(with image: UIImage?, presentingVC: UIViewController) -> FiltersRouter
}

class FiltersBuilderImpl: FiltersBuilder {
    func build(with image: UIImage?, presentingVC: UIViewController) -> FiltersRouter {
        let view = FiltersViewImpl()
        let coordinator = FiltersCoordinator(
            view: view,
            presentingVC: presentingVC
        )
        let model = FiltersModelImpl()
        let presenter = FiltersPresenterImpl(
            model: model,
            view: view,
            coordinator: coordinator,
            image: image
        )
        view.presenter = presenter
        return coordinator
    }
}
