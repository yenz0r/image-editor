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
    func animateScaleButton(selected: Bool)
    func animateRotateButton(selected: Bool)

}

class PreviewViewImpl: UIViewController {
    private var imageView: UIImageView!
    private var stackView: UIStackView!

    private var controlPanel: UIView!
    private var scaleButton: UIButton!
    private var rotateButton: UIButton!
    private var scaleSlider: UISlider!
    private var rotateSlider: UISlider!
    private var scaleValueLabel: UILabel!
    private var rotateValueLabel: UILabel!
    private var rotateContainerView: UIView!
    private var scaleContainerView: UIView!

    private var rotateStartTransform: CGAffineTransform!
    private var scaleStartTransform: CGAffineTransform!

    var presenter: PreviewPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black

        self.scaleButton = self.setupScaleButton()
        self.rotateButton = self.setupRotateButton()
        self.controlPanel = self.setupControlPanel()

        self.scaleSlider = self.setupScaleSlider()
        self.rotateSlider = self.setupRotateSlider()

        self.scaleValueLabel = self.setupScaleLabel()
        self.rotateValueLabel = self.setupRotateLabel()

        self.rotateContainerView = self.setupRotateContainerView()
        self.scaleContainerView = self.setupScaleContainerView()

        self.imageView = self.setupImageView()
        self.stackView = self.setupStackView()
        self.configureNavBar()

        self.presenter.viewDidLoad()
    }

    private func setupImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(20.0)
            make.center.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        return imageView
    }

    private func setupScaleLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }

    private func setupRotateLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }

    private func configureNavBar() {
        self.navigationItem.title = "Preview Screen"
    }

    private func setupScaleButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Scale", for: .normal)
        button.addTarget(self, action: #selector(handleScaleButtonTap), for: .touchUpInside)
        button.backgroundColor = .blue
        return button
    }

    private func setupRotateButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Rotate", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleRotateButtonTap), for: .touchUpInside)
        button.backgroundColor = .green
        return button
    }

    private func setupScaleContainerView() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        self.view.addSubview(view)
        view.snp.makeConstraints { make in
            make.top.size.equalTo(self.controlPanel)
            make.trailing.equalTo(self.view.snp.leading)
        }

        let closeButton = UIButton(type: .system)
        closeButton.backgroundColor = .red
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(self.view.frame.width / 3)
        }
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(self, action: #selector(handleCloseButtonTap), for: .touchUpInside)
        closeButton.tag = 0

        view.addSubview(self.scaleSlider)
        self.scaleSlider.snp.makeConstraints { make in
            make.leading.equalTo(closeButton.snp.trailing).offset(10.0)
            make.trailing.equalToSuperview().offset(-10.0)
            make.top.equalToSuperview().offset(10.0)
        }

        view.addSubview(self.scaleValueLabel)
        self.scaleValueLabel.snp.makeConstraints { make in
            make.leading.equalTo(closeButton.snp.trailing).offset(10.0)
            make.trailing.equalToSuperview().offset(-10.0)
            make.bottom.equalToSuperview().offset(-10.0)
        }

        return view
    }

    @objc private func handleCloseButtonTap(_ sender: UIButton) {
        if sender.tag == 0 {
            self.animateScaleButton(selected: false)
        } else {
            self.animateRotateButton(selected: false)
        }

    }

    private func setupRotateContainerView() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        self.view.addSubview(view)
        view.snp.makeConstraints { make in
            make.top.size.equalTo(self.controlPanel)
            make.leading.equalTo(self.view.snp.trailing)
        }

        let closeButton = UIButton(type: .system)
        closeButton.backgroundColor = .red
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.width.equalTo(self.view.frame.width / 3)
        }
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(self, action: #selector(handleCloseButtonTap), for: .touchUpInside)
        closeButton.tag = 1

        view.addSubview(self.rotateSlider)
        self.rotateSlider.snp.makeConstraints { make in
            make.trailing.equalTo(closeButton.snp.leading).offset(-10.0)
            make.leading.equalToSuperview().offset(10.0)
            make.top.equalToSuperview().offset(10.0)
        }

        view.addSubview(self.rotateValueLabel)
        self.rotateValueLabel.snp.makeConstraints { make in
            make.trailing.equalTo(closeButton.snp.leading).offset(10.0)
            make.leading.equalToSuperview().offset(10.0)
            make.bottom.equalToSuperview().offset(-10.0)
        }

        return view
    }

    @objc private func handleScaleButtonTap() {
        self.animateScaleButton(selected: true)
    }

    @objc private func handleRotateButtonTap() {
        self.animateRotateButton(selected: true)
    }

    private func setupControlPanel() -> UIView {
        let view = UIView()
        self.view.addSubview(view)
        view.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(70.0)
        }
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(70.0)
        }
        stackView.addArrangedSubview(self.scaleButton)
        stackView.addArrangedSubview(self.rotateButton)

        return view
    }

    private func setupRotateSlider() -> UISlider {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 0
        slider.addTarget(self, action: #selector(rotateSliderValueChanges(_:)), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderStartValueUpdate(slider:)), for: .touchDown)
        slider.addTarget(self, action: #selector(sliderStartValueUpdate(slider:)), for: .touchCancel)
        slider.tag = 0
        return slider
    }

    private func setupScaleSlider() -> UISlider {
        let slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 2
        slider.value = 1
        slider.addTarget(self, action: #selector(scaleSliderValueChanged), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderStartValueUpdate(slider:)), for: .touchDown)
        slider.addTarget(self, action: #selector(sliderStartValueUpdate(slider:)), for: .touchCancel)
        slider.tag = 1
        return slider
    }

    @objc private func sliderStartValueUpdate(slider: UISlider) {
        switch slider.tag {
        case 0:
            self.rotateStartTransform = self.imageView.transform
        case 1:
            self.scaleStartTransform = self.imageView.transform
        default:
            print("incorrect tag")
        }
    }

    @objc private func scaleSliderValueChanged(_ sender: UISlider) {
        let currentValue = sender.value
        self.updateValueLabel(text: "value: \(currentValue)", for: self.scaleValueLabel)
        self.scaleImage(to: currentValue)
    }

    @objc private func rotateSliderValueChanges(_ sender: UISlider) {
        let currentValue = sender.value
        self.updateValueLabel(text: "value: \(currentValue)", for: self.rotateValueLabel)
        self.rotateImage(to: currentValue)
    }

    private func updateValueLabel(text: String, for label: UILabel) {
        label.text = text
    }

    private func scaleImage(to value: Float) {
        let value = CGFloat(value)
        self.imageView.transform = self.scaleStartTransform.scaledBy(x: value - 1, y: value - 1)
    }

    private func rotateImage(to value: Float) {
        let value = CGFloat(value)
        self.imageView.transform = self.rotateStartTransform.rotated(by: .pi * value)
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
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        return stackView
    }
}

extension PreviewViewImpl: PreviewView {
    func animateScaleButton(selected: Bool) {
        if selected {
            UIView.animate(withDuration: 1.0) {
                self.controlPanel.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
                self.scaleContainerView.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
            }
        } else {
            UIView.animate(withDuration: 1.0) {
                self.controlPanel.transform = CGAffineTransform.identity
                self.scaleContainerView.transform = CGAffineTransform.identity
            }
        }
    }

    func animateRotateButton(selected: Bool) {
        if selected {
            UIView.animate(withDuration: 1.0) {
                self.controlPanel.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
                self.rotateContainerView.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
            }
        } else {
            UIView.animate(withDuration: 1.0) {
                self.controlPanel.transform = CGAffineTransform.identity
                self.rotateContainerView.transform = CGAffineTransform.identity
            }
        }
    }

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
