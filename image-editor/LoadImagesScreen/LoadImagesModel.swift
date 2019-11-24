//
//  LoadImagesModel.swift
//  image-editor
//
//  Created by yenz0redd on 20.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol LoadImagesModel: AnyObject {
    func getImages(fromBegining: Bool, completion: @escaping (_ images: [UIImage?]) -> Void)
    func imageForURL(_ url: String?, completion: @escaping (_ image: UIImage?) -> Void)
    var images: [UIImage?] { get }
}

final class LoadImagesModelImpl {
    private var loadedImages = [UIImage?]()
    private let downloadService = DonwloadService.shared
}

// MARK: - LoadImagesModel implementation
extension LoadImagesModelImpl: LoadImagesModel {
    var images: [UIImage?] {
        return self.loadedImages
    }

    func imageForURL(_ url: String?, completion: @escaping (_ image: UIImage?) -> Void) {
        self.downloadService.downloadImageForUrl(url: url, completion: completion)
    }

    func getImages(fromBegining: Bool, completion: @escaping (_ images: [UIImage?]) -> Void) {
        self.downloadService.downloadImages(fromBegining: fromBegining, completion: { images in
            self.loadedImages.append(contentsOf: images)
            completion(images)
        })
    }
}
