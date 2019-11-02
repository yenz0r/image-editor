//
//  ColorsService.swift
//  image-editor
//
//  Created by yenz0redd on 30.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit
import CoreImage

final class ColorsService {
    enum FilterType {
        case britness, contrast, saturation
    }

    private func useFiter(for image: UIImage?,
                    to value: Float,
                    by filter: CIFilter?,
                    with key: String) -> UIImage? {
        let context = CIContext(options: nil)
        guard let image = image else { return nil }
        guard let beginImage = CIImage(image: image) else { return nil }
        guard let filter = filter else { return nil }
        filter.setValue(beginImage, forKey: kCIInputImageKey)
        filter.setValue(value, forKey: key)
        guard let filteredImage = filter.outputImage else { return nil }
        guard let cgImage = context.createCGImage(filteredImage, from: filteredImage.extent) else { return nil }
        return UIImage(cgImage: cgImage, scale: 1.0, orientation: UIImage.Orientation.right)
    }

    func setupFilter(for image: UIImage?,
                     to value: Float,
                     by type: FilterType) -> UIImage? {
        var filter: CIFilter?
        var key: String

        switch type {
        case .britness:
            filter = CIFilter(name: "CIColorControls")
            key = kCIInputBrightnessKey
        case .contrast:
            filter = CIFilter(name: "CIColorControls")
            key = kCIInputContrastKey
        case .saturation:
            filter = CIFilter(name: "CIColorControls")
            key = kCIInputSaturationKey
        }
        DispatchQueue.global(qos: .utility).async {

        }
        return self.useFiter(for: image, to: value, by: filter, with: key)
    }
}
