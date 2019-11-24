//
//  StartPresenter.swift
//  image-editor
//
//  Created by yenz0redd on 17.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol StartPresenter {
    func viewDidLoad()
    func handleButtonTap(at index: Int)
}

final class StartPresenterImpl {
    private weak var view: StartView?
    private let router: StartRouter

    private var buttonsActions: [() -> Void] = []

    init(view: StartView,
         coordinator: StartRouter) {
        self.view = view
        self.router = coordinator
    }
}

// MARK: - StartPresenter implementation
extension StartPresenterImpl: StartPresenter {
    func viewDidLoad() {
        self.view?.setupTitle("Image Editor :D")
        self.addButton(title: "Network", index: 0, color: .orange) {
            self.router.showLoadImagesScreen()
        }
        self.addButton(title: "Camera", index: 1, color: .green) {
            self.router.showCameraScreen()
        }
        self.addButton(title: "Gallery", index: 2, color: .blue) {
            self.router.showGallerySreen()
        }
    }

    func handleButtonTap(at index: Int) {
        self.buttonsActions[index]()
    }

    private func addButton(title: String, index: Int, color: UIColor, action: @escaping () -> Void) {
        self.view?.addButton(title: title, index: index, color: color, action: action)
        self.buttonsActions.append(action)
    }
}
