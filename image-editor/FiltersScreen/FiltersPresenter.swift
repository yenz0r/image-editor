//
//  FiltersPresenter.swift
//  image-editor
//
//  Created by yenz0redd on 30.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol FiltersPresenter: AnyObject {
    func viewDidLoad()
    func handleFilterChoose(at indexPath: IndexPath)
    var processedImages: [UIImage?] { get }
    func handleNextButtonTap()
}

final class FiltersPresenterImpl {
    private let model: FiltersModel!
    private let view: FiltersView!
    private let router: FiltersRouter!
    private var image: UIImage!
    private var resultImage: UIImage!

    private var filteredImages = [UIImage?]()

    var processedImages: [UIImage?] {
        return self.filteredImages
    }

    init(model: FiltersModel,
         view: FiltersView,
         coordinator: FiltersRouter,
         image: UIImage?) {
        self.model = model
        self.view = view
        self.router = coordinator
        self.image = image
    }
}

extension FiltersPresenterImpl: FiltersPresenter {
    func viewDidLoad() {
        self.view.setupImage(self.image)
        self.view.startAnimation()
        DispatchQueue.global(qos: .userInteractive).async {
            self.model.applyAllFilters(for: self.image) { images in
                self.filteredImages = images
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.view.reloadData()
                    self.view.stopAnimation()
                }
            }
        }
    }

    func handleFilterChoose(at indexPath: IndexPath) {
        self.view.startAnimation()
        DispatchQueue.global(qos: .userInteractive).async {
            self.model.applyFilter(for: self.model.filters[indexPath.row], image: self.image) { image in
                DispatchQueue.main.async {
                    self.view.setupImage(image)
                    self.resultImage = image
                    self.view.stopAnimation()
                }
            }
        }
    }

    func handleNextButtonTap() {
        if self.resultImage == nil {
            self.router.showColorsScreen(with: self.image)
        } else {
            self.router.showColorsScreen(with: self.resultImage)
        }
    }
}
