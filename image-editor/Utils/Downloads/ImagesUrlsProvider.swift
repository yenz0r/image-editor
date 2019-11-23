//
//  ImagesUrls.swift
//  image-editor
//
//  Created by yenz0redd on 02.11.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import Foundation

final class ImagesUrlsProvider {
    static let shared = ImagesUrlsProvider()

    private init() { }

    private let baseUrl = "https://source.unsplash.com/featured"
    private let tags = [
        "canada",
        "love",
        "nature",
        "architecture",
        "christmas",
        "sky",
        "animals",
        "cars",
        "sea",
        "art",
        "cats",
        "geometry",
        "cola",
        "fashion",
        "fire",
        "flower",
        "food",
        "forest",
        "halloween",
        "human"
    ]

    func getUrls(for number: Int) -> [String] {
        var result = [String]()
        (0..<number).forEach { _ in
            let randomIndex = Int.random(in: 0..<self.tags.count)
            let url = "\(self.baseUrl)/?\(tags[randomIndex])"
            result.append(url)
        }
        return result
    }

}
