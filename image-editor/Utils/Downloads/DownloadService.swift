//
//  DownloadService.swift
//  image-editor
//
//  Created by yenz0redd on 02.11.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

final class DonwloadService {
    private var images = [UIImage?]()
    private let cacheService = ImagesCache.shared
    static let shared = DonwloadService()

    private init() { }

    func downloadImages(completion: ((_ images: [UIImage?]) -> Void)?) {
        let urls = ImagesUrlsProvider.imagesURLs
        let dispatchGroup = DispatchGroup()
        urls.indices.forEach {_ in dispatchGroup.enter() }
        for stringURL in urls {
            if let image = cacheService.getImage(for: stringURL) {
                self.images.append(image)
                dispatchGroup.leave()
                continue
            }

            guard let url = URL(string: stringURL) else { continue }
            let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, err in
                guard err == nil, let data = data else { return }
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    if let resultImage = image {
                        self?.cacheService.appendImage(resultImage, with: stringURL)
                        self?.images.append(image)
                    }
                }
                dispatchGroup.leave()
            }
            dataTask.resume()
        }
        dispatchGroup.notify(queue: .main) {
            completion?(self.images)
        }
    }

    func downloadImageForUrl(url: String?, completion: ((_ images: UIImage?) -> Void)?) {
        guard let stringURL = url, let url = URL(string: stringURL) else { return }

        if let image = cacheService.getImage(for: stringURL) {
            completion?(image)
            return
        }

        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, err in
            guard err == nil, let data = data else { return }
            let image = UIImage(data: data)
            if let resultImage = image {
                self?.cacheService.appendImage(resultImage, with: stringURL)
            }
            completion?(image)
        }
        dataTask.resume()
    }
}
