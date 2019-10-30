//
//  StartModel.swift
//  image-editor
//
//  Created by yenz0redd on 17.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import Foundation

protocol StartModel {
    func addButton(title: String, action: (() -> ())?)
    func actionForIndex(at index: Int) -> (() -> ())?
}

struct ActionButton {
    let title: String
    let action: (() -> Void)?
}

class StartModelImpl: StartModel {
    private var actionButtons = [ActionButton]()

    func addButton(title: String, action: (() -> ())?) {
        let actionButton = ActionButton(title: title, action: action)
        self.actionButtons.append(actionButton)
    }

    func actionForIndex(at index: Int) -> (() -> ())? {
        guard self.actionButtons.indices.contains(index) else {
            return nil
        }
        return self.actionButtons[index].action
    }
}