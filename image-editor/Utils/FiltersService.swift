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
    private(set) var filters = ["CISepiaTone"]
    private let emptyImage = UIImage(named: "asd")
    private let inputImage: UIImage?

    init(inputImage: UIImage?) {
        self.inputImage = inputImage
    }

    func applyFilter(at index: Int) -> UIImage? {
        let context = CIContext(options: nil)

        guard let startImage = self.inputImage, let ciImage = CIImage(image: startImage)  else {
            return self.emptyImage
        }

        guard index < self.filters.count, let currentFilter = CIFilter(name: self.filters[index]) else {
            return self.emptyImage
        }

        currentFilter.setValue(ciImage, forKey: kCIInputImageKey)
        currentFilter.setValue(0.5, forKey: kCIInputIntensityKey)

        guard let output = currentFilter.outputImage, let cgimg = context.createCGImage(output, from: output.extent) else {
            return self.emptyImage
        }

        return UIImage(cgImage: cgimg)
    }
}
