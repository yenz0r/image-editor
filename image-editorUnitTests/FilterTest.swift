//
//  FilterTest.swift
//  image-editorUnitTests
//
//  Created by yenz0redd on 08.12.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import XCTest
@testable import image_editor

class FiltersProviderMock_1: FiltersProviderable {
    let testableFilter = "CISepiaTone"

    var filters: [String : [FilterKey]?] {
        let filterKey = FilterKey(
            name: kCIInputIntensityKey,
            minimumValue: 3.0,
            maximumValue: -3.0,
            initialValue: 0.4
        )
        return [self.testableFilter: [filterKey]]
    }

    func updateFilterCurrentValue(for name: String, by key: String, on value: Float) { }
}

class FiltersProviderMock_2: FiltersProviderable {
    var filters: [String : [FilterKey]?] {
        let filters = self.getFiltersFromFile()
        var result: [String : [FilterKey]?] = [:]
        filters.forEach { result[$0] = nil }
        return result
    }

    func updateFilterCurrentValue(for name: String, by key: String, on value: Float) { }

    private func getFiltersFromFile() -> [String] {
        let fileManager = FileManager.default
        let testPath = "/Users/yenz0redd/Desktop/test-filters.txt"

        guard fileManager.fileExists(atPath: testPath) else { return [] }
        guard fileManager.isReadableFile(atPath: testPath) else { return [] }

        do {
            let data = try String(contentsOfFile: testPath, encoding: .utf8)
            return data.components(separatedBy: .newlines)

        } catch {
            return []
        }
    }
}

class FilterTest: XCTestCase {
    func testFilter_1() {
        let filtersProvider = FiltersProviderMock_1()
        let filtersService = FiltersService(filtersProvider: filtersProvider)
        let testableImage = UIImage(named: "empty-image")
        let resultImage = filtersService.applyFilter(for: filtersProvider.testableFilter, image: testableImage)

        XCTAssert(resultImage != nil, "FiltersService: incorrect filter")
    }

    // Data-driven test
    func testFilter_2() {
        let filtersProvider = FiltersProviderMock_2()
        let filtersService = FiltersService(filtersProvider: filtersProvider)
        let testableImage = UIImage(named: "empty-image")

        let resultImages = filtersProvider.filters.compactMap { key, _ in
            filtersService.applyFilter(for: key, image: testableImage)
        }

        XCTAssert(resultImages.count == filtersProvider.filters.keys.count, "FiltersService: dropped dataDriven test")
    }
}
