//
//  StartViewController.swift
//  image-editor
//
//  Created by yenz0redd on 17.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit
import SnapKit

protocol StartView: AnyObject {
    func setupTitle(_ text: String)
    func addButton(title: String, index: Int, color: UIColor, action: (() -> Void)?)
}

final class StartViewImpl: UIViewController {
    private var titleLabel: UILabel!
    private var stackView: UIStackView!
    private var stackContainerView: UIView!

    var presenter: StartPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavBar()
        self.view.backgroundColor = .black

        self.titleLabel = self.setupTitleLabel()
        self.stackContainerView = self.setupStackContainerView()
        self.stackView = self.setupStackView()
        self.presenter.viewDidLoad()
    }

    private func setupTitleLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Avenir-Roman", size: 40)!
        label.textColor = .white
        self.view.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-20.0)
        }
        return label
    }

    private func configureNavBar() {
        self.navigationItem.title = "Start Screen"
    }

    private func setupStackContainerView() -> UIView {
        let view = UIView()
        self.view.addSubview(view)
        view.layer.cornerRadius = 30.0
        view.clipsToBounds = true
        view.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(70.0)
            make.leading.trailing.equalToSuperview().inset(10.0)
            make.bottom.equalToSuperview().offset(-30.0)
        }
        return view
    }
    
    private func setupStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        self.stackContainerView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return stackView
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        self.presenter.handleButtonTap(at: sender.tag)
    }
}

// MARK: - StartView implementation
extension StartViewImpl: StartView {
    func setupTitle(_ text: String) {
        self.titleLabel.text = text
    }

    func addButton(title: String, index: Int, color: UIColor, action: (() -> Void)?) {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.tag = index
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.backgroundColor = color
        self.stackView.addArrangedSubview(button)
    }
}
