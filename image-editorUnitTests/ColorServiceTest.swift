//
//  ColorServiceTest.swift
//  image-editorUnitTests
//
//  Created by yenz0redd on 08.12.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import XCTest
@testable import image_editor

class ColorServiceTest: XCTestCase {
    func testControls() {
        let colorsService = ColorsService()
        let testableImage = UIImage(named: "empty-image")
        let testableControls: [ColorsService.FilterType] = [.britness, .contrast, .saturation]

        let resultImages = testableControls.compactMap { colorsService.setupFilter(for: testableImage, to: 2.0, by: $0) }

        XCTAssert(resultImages.count == testableControls.count, "colorsService: incorect input/output number")
    }
}
