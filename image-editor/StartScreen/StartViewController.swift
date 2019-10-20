//
//  StartViewController.swift
//  image-editor
//
//  Created by yenz0redd on 17.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit
import SnapKit

protocol StartViewController {
    func setupTitle(_ text: String)
    func addButton(title: String, index: Int, action: (() -> Void)?)
}

class StartViewControllerImpl: UIViewController {
    private var titleLabel: UILabel!
    private var stackView: UIStackView!

    var presenter: StartPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel = self.setupTitleLabel()
        self.stackView = self.setupStackView()
        self.presenter.viewDidLoad()
        self.view.backgroundColor = .white
    }

    private func setupTitleLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
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

    private func setupStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 5.0
        self.view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.titleLabel.snp.bottom).offset(20.0)
            make.leading.trailing.equalToSuperview().inset(10.0)
        }
        return stackView
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        self.presenter.handleButtonTap(at: sender.tag)
    }
}

extension StartViewControllerImpl: StartViewController {
    func setupTitle(_ text: String) {
        self.titleLabel.text = text
    }

    func addButton(title: String, index: Int, action: (() -> Void)?) {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.tag = index
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.backgroundColor = .orange
        self.stackView.addArrangedSubview(button)
    }
}
