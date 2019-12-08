//
//  FiltersModel.swift
//  image-editor
//
//  Created by yenz0redd on 30.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol FiltersModel: AnyObject {
    var filters: FiltersProvider.FiltersType { get }
    func applyFilter(for name: String, image: UIImage?, completion: ((_ image: UIImage?) -> Void)?)
    func applyAllFilters(for image: UIImage?, completion: ((_ dict: [String: UIImage?]) -> Void)?)
    func updateValue(for name: String, by key: String, on value: Float)
}

final class FiltersModelImpl {
    private let filtersService: FiltersService
    
    init() {
        self.filtersService = FiltersService()
    }
}

// MARK: - FilterModel implementation
extension FiltersModelImpl: FiltersModel {
    func updateValue(for name: String, by key: String, on value: Float) {
        self.filtersService.updateValue(for: name, by: key, on: value)
    }

    var filters: FiltersProvider.FiltersType {
        return filtersService.filters
    }

    func applyFilter(for name: String, image: UIImage?, completion: ((_ image: UIImage?) -> Void)?) {
        DispatchQueue.global(qos: .utility).async {
            let resultImage = self.filtersService.applyFilter(for: name, image: image)
            completion?(resultImage)
        }
    }

    func applyAllFilters(for image: UIImage?, completion: ((_ dict: [String: UIImage?]) -> Void)?) {
        DispatchQueue.global(qos: .utility).async {
            var result = [String: UIImage?]()
            for (key, _) in self.filters {
                let filteredImage = self.filtersService.applyFilter(for: key, image: image)
                result[key, default: nil] = filteredImage
            }

            completion?(result)
        }
    }
}
