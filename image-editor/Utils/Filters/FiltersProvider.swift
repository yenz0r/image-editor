//
//  FiltersProvider.swift
//  image-editor
//
//  Created by yenz0redd on 02.11.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import CoreImage

class FiltersProvider {
    typealias FiltersType = [String: [FilterKey]?]

    struct FilterKey {
        let name: String
        let minimumValue: Float
        let maximumValue: Float
        let initialValue: Float
        var currentValue: Float = 0.0
    }

    var filters: [String: [FilterKey]?] {
        return self.getFilters()
    }

    private func configureKey(_ name: String,
                              _ max: Float,
                              _ min: Float,
                              _ initial: Float) -> FilterKey {
        return FilterKey(name: name, minimumValue: max, maximumValue: min, initialValue: initial)
    }

    private func getFilters() -> FiltersType {
        var result: FiltersType
        result = [
            "CISepiaTone" : [
                self.configureKey(kCIInputIntensityKey, 3.0, -3.0, 0.4)
            ],
            "CIMotionBlur" : [
                self.configureKey("inputRadius", 40.0, 0.0, 20.0),
                self.configureKey("inputAngle", 3.0, -3.0, 0.0)
            ],
            "CIBloom" : [
                self.configureKey("inputRadius", 20.0, 0.0, 10.0),
                self.configureKey("inputIntensity", 1.0, -1.0, 0.5)
            ],
            "CIColorPosterize" : [
                self.configureKey("inputLevels", 15.0, 0.0, 6.0)
            ],
//            "CIWhitePointAdjust" : [
//                self.configureKey("inputColor", 255.0 / 255.0, 100.0 / 255.0, 255.0 / 255.0)
//            ],
            "CIComicEffect" : nil,
            "CIPhotoEffectInstant" : nil,
            "CIPhotoEffectProcess" : nil,
            "CIPhotoEffectTonal" : nil,
            "CIPhotoEffectTransfer" : nil,
            "CIPhotoEffectNoir" : nil
        ]
        return result
    }

    func updateFilterCurrentValue(for name: String, by key: String, on value: Float) {
        guard let keys = self.filters[name] else { return }
        guard let rightKeys = keys else { return }
        var needKey: FilterKey? = nil
        for tempKey in rightKeys {
            if tempKey.name == key {
                needKey = tempKey
                break
            }
        }
        needKey?.currentValue = value
    }
}
