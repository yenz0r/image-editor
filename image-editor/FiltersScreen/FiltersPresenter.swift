//
//  FiltersPresenter.swift
//  image-editor
//
//  Created by yenz0redd on 30.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol FiltersPresenter {
    func viewDidLoad()
    func handleFilterChoose(at indexPath: IndexPath)
    var processedImages: [UIImage?] { get }
}

class FiltersPresenterImpl: FiltersPresenter {
    private let model: FiltersModel!
    private let view: FiltersView!
    private let router: FiltersRouter!
    private let image: UIImage!

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

    func viewDidLoad() {
        self.view.setupImage(self.image)
        DispatchQueue.global(qos: .userInteractive).async {
            self.model.applyAllFilters(for: self.image) { images in
                self.filteredImages = images
                DispatchQueue.main.async {
                    self.view.reloadData()
                }
            }
        }
    }

    func handleFilterChoose(at indexPath: IndexPath) {
        DispatchQueue.global(qos: .userInteractive).async {
            self.model.applyFilter(for: self.model.filters[indexPath.row], image: self.image) { image in
                DispatchQueue.main.async {
                    self.view.setupImage(image)
                }
            }
        }
    }
}
