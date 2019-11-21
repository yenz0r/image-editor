//
//  StartPresenter.swift
//  image-editor
//
//  Created by yenz0redd on 17.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol StartPresenter {
    func viewDidLoad()
    func handleButtonTap(at index: Int)
}

final class StartPresenterImpl {
    private typealias ButtonAction = () -> Void

    private let model: StartModel
    private weak var view: StartView?
    private let router: StartRouter

    init(model: StartModel,
         view: StartView,
         coordinator: StartRouter) {
        self.model = model
        self.view = view
        self.router = coordinator
    }
}

extension StartPresenterImpl: StartPresenter {
    func viewDidLoad() {
        self.view?.setupTitle("Image Editor :D")
        self.addButton(title: "Network", index: 0, color: .orange) {
            self.router.showLoadImagesScreen()
        }
        self.addButton(title: "Camera", index: 1, color: .green) {
            self.router.showCameraScreen()
        }
        self.addButton(title: "Gallery", index: 2, color: .blue) {
            self.router.showGallerySreen()
        }
    }

    func handleButtonTap(at index: Int) {
        guard let action = self.model.actionForIndex(at: index) else {
            return
        }
        action()
    }

    private func addButton(title: String, index: Int, color: UIColor, action: ButtonAction?) {
        self.view?.addButton(title: title, index: index, color: color, action: action)
        self.model.addButton(title: title, action: action)
    }
}
