//
//  SaveBuilder.swift
//  image-editor
//
//  Created by yenz0redd on 30.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol SaveBuilder {
    func build(parentController: UIViewController,
               image: UIImage?) -> SaveCoordinator
}

class SaveBuilderImpl: SaveBuilder {
    func build(parentController: UIViewController,
               image: UIImage?) -> SaveCoordinator {
        let view = SaveViewImpl()
        let coordinator = SaveCoordinator(
            view: view,
            parentController: parentController
        )
        let presenter = SavePresenterImpl(
            view: view,
            router: coordinator,
            image: image
        )
        view.presenter = presenter
        return coordinator
    }
}
