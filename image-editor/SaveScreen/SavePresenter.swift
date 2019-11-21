//
//  SavePresenter.swift
//  image-editor
//
//  Created by yenz0redd on 30.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol SavePresenter: AnyObject {
    func viewDidAppear()
    func handleSaveButtonTap()
    func handleCloseButtonTap()
}

final class SavePresenterImpl {
    private weak var view: SaveView?
    private let router: SaveRouter
    private let startImage: UIImage?
    private let resultImage: UIImage?

    init(view: SaveView,
         router: SaveRouter,
         startImage: UIImage?,
         resultImage: UIImage?) {
        self.view = view
        self.router = router
        self.startImage = startImage
        self.resultImage = resultImage
    }
}

// MARK: - SavePresenter implementation
extension SavePresenterImpl: SavePresenter {
    func viewDidAppear() {
        self.view?.animateImagesAppearing()
        self.view?.setupImages([self.resultImage, self.startImage])
    }

    func handleSaveButtonTap() {
        self.router.saveImage(image: self.resultImage)
    }

    func handleCloseButtonTap() {
        self.router.showStartScreen()
    }
}
