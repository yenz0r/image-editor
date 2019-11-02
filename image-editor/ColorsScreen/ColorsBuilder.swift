//
//  ColorsBuilder.swift
//  image-editor
//
//  Created by yenz0redd on 30.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol ColorsBuilder: AnyObject {
    func build(parentController: UIViewController,
               image: UIImage?) -> ColorsCoordinator
}

final class ColorsBuilderImpl: ColorsBuilder {
    func build(parentController: UIViewController,
               image: UIImage?) -> ColorsCoordinator {
        let view = ColorsViewImpl()
        let coordinator = ColorsCoordinator(
            parentController: parentController,
            view: view
        )
        let model = ColorsModelImpl()
        let presenter = ColorsPresenterImpl(
            view: view,
            router: coordinator,
            model: model,
            image: image
        )
        view.presenter = presenter
        return coordinator
    }


}
