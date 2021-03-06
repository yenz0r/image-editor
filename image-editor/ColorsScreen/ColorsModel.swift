//
//  ColorsModel.swift
//  image-editor
//
//  Created by yenz0redd on 30.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol ColorsModel: AnyObject {
    func changeColor(for image: UIImage?,
                     on value: Float,
                     by filter: ColorsService.FilterType,
                     completion: @escaping (_ image: UIImage?) -> Void)
}

final class ColorsModelImpl {
    private let colorsService = ColorsService()
}

// MARK: - ColorsModel implementation
extension ColorsModelImpl: ColorsModel {
    func changeColor(for image: UIImage?,
                     on value: Float,
                     by filter: ColorsService.FilterType,
                     completion: @escaping (UIImage?) -> Void) {
        completion(
            self.colorsService.setupFilter(
                for: image,
                to: value, by: filter
            )
        )
    }
}
