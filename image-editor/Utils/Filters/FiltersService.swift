//
//  FiltersService.swift
//  image-editor
//
//  Created by egor bychkoyski on 10/30/19.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit
import CoreImage

final class FiltersService {
    private var filtersProvider: FiltersProviderable

    init() {
        filtersProvider = FiltersProvider()
    }

    //testable init
    init(filtersProvider: FiltersProviderable) {
        self.filtersProvider = filtersProvider
    }

    var filters: FiltersProvider.FiltersType {
        return filtersProvider.filters
    }
    
    func updateValue(for name: String, by key: String, on value: Float) {
        self.filtersProvider.updateFilterCurrentValue(for: name, by: key, on: value)
    }

    func applyFilter(for name: String, image: UIImage?) -> UIImage? {
        let context = CIContext(options: nil)

        guard let startImage = image, let ciImage = CIImage(image: startImage)  else {
            return nil
        }

        guard let currentFilter = CIFilter(name: name) else {
            return nil
        }

        currentFilter.setValue(ciImage, forKey: kCIInputImageKey)

        filtersProvider.filters[name]??.forEach { currentFilter.setValue($0.initialValue, forKey: $0.name) }

        guard let output = currentFilter.outputImage, let cgimg = context.createCGImage(output, from: output.extent) else {
            return nil
        }

        return UIImage(cgImage: cgimg, scale: 1.0, orientation: UIImage.Orientation.right)
    }
}
