//
//  StartBuilder.swift
//  image-editor
//
//  Created by yenz0redd on 19.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol StartBuilder {
    func build(window: UIWindow) -> StartCoordinator
}

final class StartBuilderImpl: StartBuilder {
    func build(window: UIWindow) -> StartCoordinator {
        let view = StartViewImpl()
        let coordinator = StartCoordinator(
            window: window, view: view
        )
        let presenter = StartPresenterImpl(
            view: view,
            coordinator: coordinator
        )
        view.presenter = presenter
        return coordinator
    }
}
