//
//  FiltersModel.swift
//  image-editor
//
//  Created by yenz0redd on 30.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol FiltersModel: AnyObject {
    var filters: [String] { get }
    func applyFilter(for name: String, image: UIImage?, completion: ((_ image: UIImage?) -> Void)?)
    func applyAllFilters(for image: UIImage?, completion: ((_ images: [UIImage?]) -> Void)?)
}

final class FiltersModelImpl {
    private let filtersService: FiltersService

    var filters: [String] {
        var result = [String]()
        self.filtersService.filters.forEach { result.append($0.name) }
        return result
    }

    init() {
        self.filtersService = FiltersService()
    }
}

extension FiltersModelImpl: FiltersModel {
    func applyFilter(for name: String, image: UIImage?, completion: ((_ image: UIImage?) -> Void)?) {
        completion?(self.filtersService.applyFilter(for: name, image: image))
    }

    func applyAllFilters(for image: UIImage?, completion: ((_ images: [UIImage?]) -> Void)?) {
        var result = [UIImage?]()
        for name in filters {
            let filteredImage = self.filtersService.applyFilter(for: name, image: image)
            result.append(filteredImage)
        }
        completion?(result)
    }
}
