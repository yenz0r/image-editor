//
//  ColorsPresenter.swift
//  image-editor
//
//  Created by yenz0redd on 30.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol ColorsPresenter: AnyObject {
    func viewDidLoad()
    func handleSliderChangeValue(index: Int, value: Float)
    func handleNextButtonTap()
}

final class ColorsPresenterImpl {
    private let view: ColorsView
    private let router: ColorsRouter
    private let model: ColorsModel
    private var image: UIImage?
    

    private var processedImage: UIImage?

    init(view: ColorsView,
         router: ColorsRouter,
         model: ColorsModel,
         image: UIImage?) {
        self.view = view
        self.router = router
        self.model = model
        self.image = image
    }
}

extension ColorsPresenterImpl: ColorsPresenter {
    func viewDidLoad() {
        self.view.addSliderView(title: "Brighness", tag: 0)
        self.view.addSliderView(title: "Contrast", tag: 1)
        self.view.addSliderView(title: "Saturation", tag: 2)

        self.view.setupImage(self.image)
    }

    func handleSliderChangeValue(index: Int, value: Float) {
        var filter: ColorsService.FilterType
        switch index {
        case 0:
            filter = .britness
        case 1:
            filter = .contrast
        case 2:
            filter = .saturation
        default:
            print("err index")
            return
        }
        self.view.startLoadAnimation()
        DispatchQueue.global(qos: .utility).async {
            self.model.changeColor(
                for: self.image,
                on: value,
                by: filter) { image in
                    self.processedImage = image
                    DispatchQueue.main.async {
                        self.view.setupImage(image)
                        self.view.stopLoadingAnimation()
                    }
                }
        }
    }

    func handleNextButtonTap() {
        if self.processedImage == nil {
            self.processedImage = self.image
        }
        self.router.showSaveScreen(startImage: self.image, resultImage: self.processedImage)
    }
}
