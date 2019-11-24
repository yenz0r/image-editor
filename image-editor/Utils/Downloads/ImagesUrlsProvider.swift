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
        "human",
        "green",
        "guitar"
    ]

    private var lastUsedIndex = 0

    func getUrls(fromBegining: Bool, for number: Int) -> [String] {
        if fromBegining {
            self.lastUsedIndex = 0
        }
        var result = [String]()
        let first = self.tags[self.lastUsedIndex]
        for (index, value) in self.tags.enumerated() where index != self.lastUsedIndex {
            result.append("\(self.baseUrl)/?\(first),\(value)")
        }
        self.lastUsedIndex += self.lastUsedIndex == self.tags.count ? -self.tags.count : 1
        return result
    }

}
