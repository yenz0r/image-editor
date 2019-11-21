//
//  ImagesCache.swift
//  image-editor
//
//  Created by yenz0redd on 21.11.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

final class ImagesCache {
    static let shared = ImagesCache()

    private init() { }

    private let cache = NSCache<NSString, UIImage>()

    func appendImage(_ image: UIImage, with url: String) {
        self.cache.setObject(image, forKey: url as NSString)
    }

    func getImage(for url: String) -> UIImage? {
        return self.cache.object(forKey: url as NSString)
    }
}
