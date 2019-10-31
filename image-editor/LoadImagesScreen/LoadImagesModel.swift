//
//  LoadImagesModel.swift
//  image-editor
//
//  Created by yenz0redd on 20.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol LoadImagesModel {
    func getImages(completion: @escaping (_ images: [UIImage?]) -> Void)
    func imageForIndexPath(_ indexPath: IndexPath) -> UIImage?
    func imageForURL(_ url: String?, completion: @escaping (_ image: UIImage?) -> Void)
}

class LoadImagesModelImpl: LoadImagesModel {
    private var images = [UIImage?]()
    private let imagesURL = [
        "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/nature-quotes-1557340276.jpg?crop=0.666xw:1.00xh;0.168xw,0&resize=640:*",
        "https://horizon-media.s3-eu-west-1.amazonaws.com/s3fs-public/field/image/ecosystem.jpg",
        "https://static.scientificamerican.com/sciam/cache/file/EAF12335-B807-4021-9AC95BBA8BEE7C8D_source.jpg?w=590&h=800&74A94564-944F-4349-96BD18788411EAA6",
        "https://soulspartan.files.wordpress.com/2017/02/nature-2-26-17.jpg",
        "https://cdn.pixabay.com/photo/2018/06/14/13/04/nature-3474826_960_720.jpg",
        "https://natureconservancy-h.assetsadobe.com/is/image/content/dam/tnc/nature/en/photos/tnc_48980557.jpg?crop=961,0,1928,2571&wid=600&hei=800&scl=3.21375",
        "https://buddhisteconomics.net/wp-content/uploads/2017/10/hdwp693968124.jpg",
        "https://www.brinknews.com/wp-content/uploads/2019/09/GettyImages-81794997.jpg",
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTbxR6Y-3rTGmQnftGvUiOhXjrWfAQ4JQDRWyxqNExuYkVrDgkxyg",
        "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/nature-quotes-1557340276.jpg?crop=0.666xw:1.00xh;0.168xw,0&resize=640:*",
        "https://horizon-media.s3-eu-west-1.amazonaws.com/s3fs-public/field/image/ecosystem.jpg"
    ]

    func imageForIndexPath(_ indexPath: IndexPath) -> UIImage? {
        guard indexPath.row < self.images.count else { return nil }
        return self.images[indexPath.row]
    }
    
    func imageForURL(_ url: String?, completion: @escaping (_ image: UIImage?) -> Void) {
        guard let stringURL = url, let url = URL(string: stringURL) else { return }
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, err in
            guard err == nil, let data = data else { return }
            let image = UIImage(data: data)
            completion(image)
        }
        dataTask.resume()
    }
    
    func getImages(completion: @escaping (_ images: [UIImage?]) -> Void) {
        let dispatchGroup = DispatchGroup()
        self.imagesURL.indices.forEach {_ in dispatchGroup.enter() }
        for stringURL in self.imagesURL {
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
            completion(self.images)
        }
    }
}
