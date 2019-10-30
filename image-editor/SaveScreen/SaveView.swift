//
//  SaveView.swift
//  image-editor
//
//  Created by yenz0redd on 30.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol SaveView {
    func setupImage(_ image: UIImage?)
    func animateImageView()
}

class SaveViewImpl: UIViewController {
    private var imageView: UIImageView!
    private var saveButton: UIButton!

    var presenter: SavePresenter!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView = self.setupImageView()
        self.saveButton = self.setupSaveButton()

        self.presenter.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.presenter.viewDidAppear()
    }

    private func setupImageView() -> UIImageView {
        let imageView = UIImageView()
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(imageView.snp.width)
        }
        imageView.contentMode = .scaleAspectFill
        return imageView
    }

    private func setupSaveButton() -> UIButton {
        let button = UIButton(type: .system)
        self.view.addSubview(button)
        button.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.top.equalTo(self.imageView.snp.bottom)
        }
        button.backgroundColor = .green
        button.setTitle("SAVE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }

    @objc private func saveButtonTapped() {
        self.presenter.handleSaveButtonTap()
    }
}

extension SaveViewImpl: SaveView {
    func setupImage(_ image: UIImage?) {
        self.imageView.image = image
    }

    func animateImageView() {
        let startTransform = self.imageView.transform
        self.imageView.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
        UIView.animate(withDuration: 1) {
            self.imageView.transform = startTransform
        }
    }


}
