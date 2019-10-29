//
//  StartPresenter.swift
//  image-editor
//
//  Created by yenz0redd on 17.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import Foundation

protocol StartPresenter {
    func viewDidLoad()
    func handleButtonTap(at index: Int)
}

class StartPresenterImpl: StartPresenter {
    private typealias ButtonAction = () -> Void

    private var model: StartModel!
    private var view: StartViewController!
    private var router: StartRouter!

    init(model: StartModel,
         view: StartViewController,
         coordinator: StartRouter) {
        self.model = model
        self.view = view
        self.router = coordinator
    }

    func viewDidLoad() {
        self.view.setupTitle("Choose mode")
        self.addButton(title: "0", index: 0) {
            self.router.showLoadImagesScreen()
        }
        self.addButton(title: "Camera", index: 1) {
            self.router.showCameraScreen()
        }
        self.addButton(title: "Gallery", index: 2) {
            self.router.showGallerySreen()
        }
    }

    func handleButtonTap(at index: Int) {
        guard let action = self.model.actionForIndex(at: index) else {
            return
        }
        action()
    }

    private func addButton(title: String, index: Int, action: ButtonAction?) {
        self.view.addButton(title: title, index: index, action: action)
        self.model.addButton(title: title, action: action)
    }
}
