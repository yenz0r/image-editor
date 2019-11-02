//
//  SaveView.swift
//  image-editor
//
//  Created by yenz0redd on 30.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol SaveView: AnyObject {
    func setupImages(_ image: [UIImage?])
    func animateImagesAppearing()
}

final class SaveViewImpl: UIViewController {
    private var scrollView: UIScrollView!
    private var scrollContentView: UIView!
    private var saveButton: UIButton!
    private var exitButton: UIButton!
    private var stackView: UIStackView!
    private var stackContainerView: UIView!

    var presenter: SavePresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavBar()
        self.view.backgroundColor = .black

        self.scrollView = self.setupScrollView()
        self.scrollContentView = self.setupScrollContentView()
        self.stackContainerView = self.setupStackContainerView()
        self.stackView = self.setupStackVeiw()
        self.saveButton = self.setupSaveButton()
        self.exitButton = self.setupExitButton()

        self.presenter.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.presenter.viewDidAppear()
    }

    private func configureNavBar() {
        self.navigationItem.title = "Save Screen"
    }

    private func setupScrollContentView() -> UIView {
        let view = UIView()
        self.scrollView.addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return view
    }

    private func setupScrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(scrollView.snp.width)
        }
        return scrollView
    }

    private func setupStackContainerView() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 30.0
        view.clipsToBounds = true
        self.view.addSubview(view)
        view.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(20.0)
            make.top.equalTo(self.scrollView.snp.bottom).offset(50.0)
        }
        return view
    }

    private func setupStackVeiw() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually

        self.stackContainerView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        return stackView
    }

    private func setupSaveButton() -> UIButton {
        let button = UIButton(type: .system)
        self.stackView.addArrangedSubview(button)
        button.backgroundColor = .green
        button.setTitle("SAVE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return button
    }

    private func setupExitButton() -> UIButton {
        let button = UIButton(type: .system)
        self.stackView.addArrangedSubview(button)
        button.backgroundColor = .red
        button.setTitle("EXIT", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)
        return button
    }

    @objc private func saveButtonTapped() {
        self.presenter.handleSaveButtonTap()
    }

    @objc private func exitButtonTapped() {
        self.presenter.handleCloseButtonTap()
    }
}

extension SaveViewImpl: SaveView {
    func setupImages(_ images: [UIImage?]) {
        let imagesCount = images.count
        for (index, image) in images.enumerated() {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.image = image
            self.scrollView.addSubview(imageView)

            let width = self.view.frame.size.width
            let size = CGSize(width: width, height: width)
            let leadingOffset = width * CGFloat(index)

            imageView.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(leadingOffset)
                make.bottom.top.equalToSuperview()
                make.size.equalTo(size)

                if index == imagesCount - 1 {
                    make.trailing.equalToSuperview()
                }
            }
        }
    }

    func animateImagesAppearing() {
        let startTransform = self.scrollView.transform
        self.scrollView.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
        UIView.animate(withDuration: 1) {
            self.scrollView.transform = startTransform
        }
    }
}
