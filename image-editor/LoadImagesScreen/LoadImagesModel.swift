//
//  LoadImagesModel.swift
//  image-editor
//
//  Created by yenz0redd on 20.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol LoadImagesModel: AnyObject {
    func getImages(completion: @escaping (_ images: [UIImage?]) -> Void)
    func imageForIndexPath(_ indexPath: IndexPath) -> UIImage?
    func imageForURL(_ url: String?, completion: @escaping (_ image: UIImage?) -> Void)
}

final class LoadImagesModelImpl {
    private var images = [UIImage?]()
    private let downloadService = DonwloadService.shared
}

// MARK: - LoadImagesModel implementation
extension LoadImagesModelImpl: LoadImagesModel {
    func imageForIndexPath(_ indexPath: IndexPath) -> UIImage? {
        guard indexPath.row < self.images.count else { return nil }
        return self.images[indexPath.row]
    }

    func imageForURL(_ url: String?, completion: @escaping (_ image: UIImage?) -> Void) {
        self.downloadService.downloadImageForUrl(url: url, completion: completion)
    }

    func getImages(completion: @escaping (_ images: [UIImage?]) -> Void) {
        self.downloadService.downloadImages(completion: { images in
            self.images = images
            completion(images)
        })
    }
}
