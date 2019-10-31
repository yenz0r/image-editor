//
//  ColorsView.swift
//  image-editor
//
//  Created by yenz0redd on 30.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol ColorsView {
    func addSliderView(title: String, tag: Int)
    func setupImage(_ image: UIImage?)
    func startLoadAnimation()
    func stopLoadingAnimation()
}

final class ColorsViewImpl: UIViewController {
    private var imageView: UIImageView!
    private var controlsPanel: UIView!
    private var stackView: UIStackView!

    var presenter: ColorsPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black

        self.imageView = self.setupImageView()
        self.controlsPanel = self.setupControlsPabel()
        self.stackView = self.setupStackView()
        self.configureNavBar()

        self.presenter.viewDidLoad()
    }

    private func configureNavBar() {
        let barItem = UIBarButtonItem(
            title: "Next",
            style: .plain,
            target: self,
            action: #selector(nextButtonTapped)
        )
        self.navigationItem.rightBarButtonItem = barItem
    }

    @objc private func nextButtonTapped() {
        self.presenter.handleNextButtonTap()
    }

    private func setupImageView() -> UIImageView {
        let imageView = UIImageView()
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
            make.leading.trailing.equalToSuperview().inset(10.0)
        }
        imageView.contentMode = .scaleAspectFit
        return imageView
    }

    private func setupControlsPabel() -> UIView {
        let view = UIView()
        self.view.addSubview(view)
        view.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(100)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-10.0)
        }
        return view
    }

    private func setupStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 20.0

        self.controlsPanel.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        return stackView
    }
}

extension ColorsViewImpl: ColorsView {
    func addSliderView(title: String, tag: Int) {
        let containerView = UIView()

        let slider = UISlider()
        slider.tag = tag
        slider.minimumValue = -1.0
        slider.maximumValue = 1.0
        slider.value = 0.0
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .touchUpInside)

        containerView.addSubview(slider)
        slider.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20.0)
        }

        let label = UILabel()
        containerView.addSubview(label)
        label.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.leading.equalTo(slider.snp.trailing).offset(10.0)
        }

        label.text = title
        label.textColor = .white
        label.textAlignment = .center

        self.stackView.addArrangedSubview(containerView)
    }

    func startLoadAnimation() {
        let alertController = UIAlertController(title: "Loading..", message: "Filter is in progress..", preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
    }

    func stopLoadingAnimation() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc private func sliderValueChanged(slider: UISlider) {
        self.presenter.handleSliderChangeValue(
            index: slider.tag,
            value: slider.value
        )
    }

    func setupImage(_ image: UIImage?) {
        self.imageView.image = image
    }
}
