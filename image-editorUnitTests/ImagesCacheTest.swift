//
//  ImagesCacheTest.swift
//  image-editorUnitTests
//
//  Created by yenz0redd on 08.12.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import XCTest
@testable import image_editor

class ImagesCacheTest: XCTestCase {
    func testWriteRead() {
        let imagesChache = ImagesCache.shared
        let numberOfOperations = Int.random(in: 0...10)
        let testableRange = (0...numberOfOperations)

        testableRange.forEach { imagesChache.appendImage(UIImage(), with: "hashvalueby\($0)") }

        let resultImages = testableRange.map { imagesChache.getImage(for: "hashvalueby\($0)") }

        XCTAssert(resultImages.count == testableRange.count, "imagesCache: not equal count input/output images")
    }

    func testClear() {
        let imagesChache = ImagesCache.shared
        let testableRange = (0...2)

        testableRange.forEach { imagesChache.appendImage(UIImage(), with: "hashvalueby\($0)") }

        imagesChache.clearCache()

        let resultImages = testableRange.compactMap { imagesChache.getImage(for: "hashvalueby\($0)") }

        XCTAssert(resultImages.count == 0, "imagesCache: not cleared")
    }
}
