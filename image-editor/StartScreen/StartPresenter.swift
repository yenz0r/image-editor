//
//  StartPresenter.swift
//  image-editor
//
//  Created by yenz0redd on 17.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import Foundation

protocol StartPresenter {
    func viewDidLoad()
    func handleButtonTap(at index: Int)
}

class StartPresenterImpl: StartPresenter {
    private typealias ButtonAction = () -> Void

    private var model: StartModel!
    private var view: StartViewController!
    private var coordinator: StartCoordinator!

    init(model: StartModel,
         view: StartViewController,
         coordinator: StartCoordinator) {
        self.model = model
        self.view = view
        self.coordinator = coordinator
    }

    func viewDidLoad() {
        self.view.setupTitle("Choose mode")
        self.addButton(title: "0", index: 0) {
            self.coordinator.showLoadImagesScreen()
        }
        self.addButton(title: "1", index: 1) {
            print("1")
        }
        self.addButton(title: "2", index: 2) {
            print("2")
        }
    }

    func handleButtonTap(at index: Int) {
        guard let action = self.model.actionForIndex(at: index) else {
            return
        }
        action()
    }

    private func addButton(title: String, index: Int, action: ButtonAction?) {
        self.view.addButton(title: title, index: index, action: action)
        self.model.addButton(title: title, action: action)
    }
}
