//
//  FiltersService.swift
//  image-editor
//
//  Created by egor bychkoyski on 10/30/19.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit
import CoreImage

class FiltersService {
    struct FilterType {
        let name: String
        let key: String?
    }

    private(set) var filters = [
        FilterType(name: "CISepiaTone", key: kCIInputIntensityKey), 
        FilterType(name: "CIMotionBlur", key: kCIInputAngleKey),
        FilterType(name: "CIComicEffect", key: nil),
        FilterType(name: "CIBloom", key: kCIInputIntensityKey),
        FilterType(name: "CIColorInvert", key: nil),
        FilterType(name: "CIColorPosterize", key: "inputLevels"),
        FilterType(name: "CIPhotoEffectNoir", key: nil),
        FilterType(name: "CIPhotoEffectProcess", key: nil),
        FilterType(name: "CIPhotoEffectTonal", key: nil),
        FilterType(name: "CIPhotoEffectTransfer", key: nil)
    ]

    private let emptyImage = UIImage(named: "empty-image")

    func applyFilter(for name: String, image: UIImage?) -> UIImage? {
        let context = CIContext(options: nil)

        guard let filter = self.filterForName(name) else {
            return self.emptyImage
        }

        guard let startImage = image, let ciImage = CIImage(image: startImage)  else {
            return self.emptyImage
        }

        guard let currentFilter = CIFilter(name: filter.name) else {
            return self.emptyImage
        }

        currentFilter.setValue(ciImage, forKey: kCIInputImageKey)
        if let key = filter.key {
            currentFilter.setValue(0.5, forKey: key)
        }

        guard let output = currentFilter.outputImage, let cgimg = context.createCGImage(output, from: output.extent) else {
            return self.emptyImage
        }

        return UIImage(cgImage: cgimg)
    }

    private func filterForName(_ name: String) -> FilterType? {
        return self.filters.first(where: { $0.name == name } )
    }
}
