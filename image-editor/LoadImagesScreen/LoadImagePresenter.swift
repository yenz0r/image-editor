//
//  LoadImagePresenter.swift
//  image-editor
//
//  Created by yenz0redd on 20.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol LoadImagesPresenter {
    func handleLoadButtonTap(with link: String?)
    func handleCellTap(at indexPath: IndexPath)
    func viewDidLoad()
    func updateImages()
    var images: [UIImage?] { get set }
}

final class LoadImagesPresenterImpl {
    var images: [UIImage?]

    private let model: LoadImagesModelImpl
    private weak var view: LoadImagesViewImpl?
    private let coordinator: LoadImagesCoordinator

    init(model: LoadImagesModelImpl,
         view: LoadImagesViewImpl,
         coordinator: LoadImagesCoordinator) {
        self.model = model
        self.view = view
        self.coordinator = coordinator
        self.images = [UIImage]()
    }
}

// MARK: - LoadImagesPresenter implementation
extension LoadImagesPresenterImpl: LoadImagesPresenter {
    func updateImages() {
        self.view?.showLoadingView()
        self.model.getImages { [weak self] images in
            self?.images = images
            self?.view?.reloadData()
            self?.view?.hideLoadingView()
        }
    }

    func viewDidLoad() {
        self.updateImages()
    }

    func handleLoadButtonTap(with link: String?) {
        self.model.imageForURL(link) { [weak self] image in
            self?.coordinator.showPreviewScreen(with: image)
        }
    }

    func handleCellTap(at indexPath: IndexPath) {
        let image = self.model.imageForIndexPath(indexPath)
        self.coordinator.showPreviewScreen(with: image)
    }
}
