//
//  SavePresenter.swift
//  image-editor
//
//  Created by yenz0redd on 30.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol SavePresenter {
    func viewDidLoad()
    func viewDidAppear()
    func handleSaveButtonTap()
    func handleCloseButtonTap()
}

class SavePresenterImpl {
    private let view: SaveView
    private let router: SaveRouter
    private let image: UIImage?

    init(view: SaveView,
         router: SaveRouter,
         image: UIImage?) {
        self.view = view
        self.router = router
        self.image = image
    }
}

extension SavePresenterImpl: SavePresenter {
    func viewDidLoad() {

    }

    func viewDidAppear() {
        self.view.setupImage(self.image)
        self.view.animateImageView()
    }

    func handleSaveButtonTap() {
        self.router.saveImage(image: self.image)
    }

    func handleCloseButtonTap() {
        print("Close")
    }
}
