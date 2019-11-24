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
    func nextImagesIfNeeded(for index: Int)
    var images: [UIImage?] { get }
}

final class LoadImagesPresenterImpl {
    private let model: LoadImagesModel
    private weak var view: LoadImagesView?
    private let coordinator: LoadImagesRouter

    init(model: LoadImagesModel,
         view: LoadImagesView,
         coordinator: LoadImagesCoordinator) {
        self.model = model
        self.view = view
        self.coordinator = coordinator
    }
}

// MARK: - LoadImagesPresenter implementation
extension LoadImagesPresenterImpl: LoadImagesPresenter {
    var images: [UIImage?] {
        return self.model.images
    }

    func nextImagesIfNeeded(for index: Int) {
        if index == self.model.images.count - 1 {
            self.view?.startPagingAnimation()
            let lastIndex = self.model.images.count
            self.model.getImages(fromBegining: false) { [weak self] images in
                let paths = (lastIndex..<images.count + lastIndex).compactMap { IndexPath(item: $0, section: 0) }
                self?.view?.insertItems(at: paths)
                self?.view?.stopPagingAnimation()
            }
        }
    }

    func updateImages() {
        self.view?.showLoadingView()
        self.model.getImages(fromBegining: true) { [weak self] images in
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
        let image = self.model.images[indexPath.row]
        self.coordinator.showPreviewScreen(with: image)
    }
}
