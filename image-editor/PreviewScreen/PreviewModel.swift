//
//  PreviewModel.swift
//  image-editor
//
//  Created by yenz0redd on 20.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol PreviewModel {
    func getActionForIndex(at index: Int) -> (() -> Void)?
    func addButton(title: String, action: (() -> Void)?)
}

class PreviewModelImpl: PreviewModel {
    private var buttons = [ActionButton]()

    func getActionForIndex(at index: Int) -> (() -> Void)? {
        guard index < self.buttons.count else {
            return nil
        }
        return self.buttons[index].action
    }

    func addButton(title: String, action: (() -> Void)?) {
        let actionButton = ActionButton(title: title, action: action)
        self.buttons.append(actionButton)
    }
}
