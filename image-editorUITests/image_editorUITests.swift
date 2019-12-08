//
//  image_editorUITests.swift
//  image-editorUITests
//
//  Created by yenz0redd on 08.12.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import XCTest

class image_editorUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    func testBasicOptions() {
        let app = XCUIApplication()
        app.launch()
        app.buttons["Network"].tap()
        sleep(10)
        app.collectionViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.tap()
        app.buttons["Scale"].tap()
        app.sliders["50%"].swipeRight()
        
        let closeButton = app.buttons["Close"]
        closeButton.tap()
        app.buttons["Rotate"].tap()
        closeButton.tap()
        app.buttons["Colors"].tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).sliders["50%"].swipeRight()
        sleep(5)
        app.navigationBars["Colors Screen"].buttons["Next"].tap()
        app.buttons["EXIT"].tap()
    }

    func testURLLoading() {
        let app = XCUIApplication()
        app.launch()

        app.buttons["Network"].tap()
        sleep(10)
        let pasteYourImageLinkTextField = app.textFields["Paste your image link.."]
        pasteYourImageLinkTextField.tap()
        pasteYourImageLinkTextField.typeText("https://www.google.by/images/branding/googlelogo/2x/googlelogo_color_160x56dp.png")
        app.buttons["Load"].tap()
        sleep(2)
        let scaleButton = app.buttons["Scale"]
        scaleButton.tap()
        app.sliders["50%"].swipeRight()
    }

}
