//
//  SaveBuilder.swift
//  image-editor
//
//  Created by yenz0redd on 30.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol SaveBuilder: AnyObject {
    func build(parentController: UIViewController,
               startImage: UIImage?,
               resultImage: UIImage?) -> SaveCoordinator
}

final class SaveBuilderImpl: SaveBuilder {
    func build(parentController: UIViewController,
               startImage: UIImage?,
               resultImage: UIImage?) -> SaveCoordinator {
        let view = SaveViewImpl()
        let coordinator = SaveCoordinator(
            view: view,
            parentController: parentController
        )
        let presenter = SavePresenterImpl(
            view: view,
            router: coordinator,
            startImage: startImage,
            resultImage: resultImage
        )
        view.presenter = presenter
        return coordinator
    }
}
