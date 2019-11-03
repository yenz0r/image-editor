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
    static let shared = DonwloadService()

    private init() { }

    func downloadImages(completion: ((_ images: [UIImage?]) -> Void)?) {
        let urls = ImagesUrlsProvider.imagesURLs
        let dispatchGroup = DispatchGroup()
        urls.indices.forEach {_ in dispatchGroup.enter() }
        for stringURL in urls {
            guard let url = URL(string: stringURL) else { continue }
            let dataTask = URLSession.shared.dataTask(with: url) { data, _, err in
                guard err == nil, let data = data else { return }
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.images.append(image)
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
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, err in
            guard err == nil, let data = data else { return }
            let image = UIImage(data: data)
            completion?(image)
        }
        dataTask.resume()
    }
}
