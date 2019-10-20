//
//  PreviewView.swift
//  image-editor
//
//  Created by yenz0redd on 20.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol PreviewView {
    func setupImage(_ image: UIImage?)
    func addButton(title: String, index: Int, action: (() -> Void)?)
}

class PreviewViewImpl: UIViewController {
    private var imageView: UIImageView!
    private var stackView: UIStackView!

    var presenter: PreviewPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.imageView = self.setupImageView()
        self.stackView = self.setupStackView()
        self.configureNavBar()

        self.presenter.viewDidLoad()
    }

    private func setupImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10.0
        imageView.layer.borderWidth = 20.0
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(20.0)
        }
        return imageView
    }

    private func configureNavBar() {
        self.navigationItem.title = "Preview Screen"
    }

    private func setupStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10.0

        self.view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(40.0)
            make.height.equalTo(30)
            make.top.equalTo(self.imageView.snp.bottom).offset(20.0)
        }
        return stackView
    }
}

extension PreviewViewImpl: PreviewView {
    @objc private func handleButtonTap(_ sender: UIButton) {
        self.presenter.handleButtonTap(at: sender.tag)
    }

    func addButton(title: String, index: Int, action: (() -> Void)?) {
        let button = UIButton(type: .system)
        button.backgroundColor = .green
        button.setTitle(title, for: .normal)
        button.tag = index
        button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
        self.stackView.addArrangedSubview(button)
    }

    func setupImage(_ image: UIImage?) {
        self.imageView.image = image
    }
}
