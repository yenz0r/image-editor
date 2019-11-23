//
//  PreviewPresenter.swift
//  image-editor
//
//  Created by yenz0redd on 20.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol PreviewPresenter: AnyObject {
    func handleButtonTap(at index: Int)
    func viewDidLoad()
}

final class PreviewPresenterImpl {
    private weak var view: PreviewView?
    private let coordinator: PreviewRouter
    private let image: UIImage?

    private var buttonsActions: [() -> Void] = []

    init(view: PreviewView,
         coordinator: PreviewRouter,
         image: UIImage?) {
        self.view = view
        self.coordinator = coordinator
        self.image = image
    }
}

// MARK: - PreviewPresenter implementation
extension PreviewPresenterImpl: PreviewPresenter {
    func handleButtonTap(at index: Int) {
        self.buttonsActions[index]()
    }

    private func setupImage(_ image: UIImage?) {
        self.view?.setupImage(image)
    }

    private func addButton(title: String, index: Int, color: UIColor, action: @escaping () -> Void) {
        self.view?.addButton(title: title, index: index, color: color, action: action)
        self.buttonsActions.append(action)
    }

    func viewDidLoad() {
        self.addButton(title: "Filters", index: 0, color: .purple) {
            self.coordinator.showEditScreen(with: self.image)
        }
        self.addButton(title: "Colors", index: 1, color: .magenta) {
            self.coordinator.showColorsScreen(with: self.image)
        }
        self.setupImage(self.image)
    }
}
