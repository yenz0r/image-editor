//
//  LoadImagesView.swift
//  image-editor
//
//  Created by yenz0redd on 20.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol LoadImagesView: AnyObject {
    func reloadData()
    func showLoadingView()
    func hideLoadingView()
}

final class LoadImagesViewImpl: UIViewController {
    private var linkLoadingContainer: UIView!
    private var linkLoadingTextField: UITextField!
    private var linkLoadingButton: UIButton!

    private var loadingView: UIView!
    private var loadingIndicator: UIActivityIndicatorView!

    private var collectionView: UICollectionView!

    var presenter: LoadImagesPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavBar()
        self.linkLoadingContainer = self.setupLinkContainer()
        self.linkLoadingTextField = self.setuplinkTextField()
        self.linkLoadingButton = self.setupLinkButton()
        self.collectionView = self.setupColletionView()
        self.loadingView = self.setupLoadingView()
        self.loadingIndicator = self.setupIndicatorView()
        self.presenter.viewDidLoad()
    }

    private func configureNavBar() {
        self.navigationItem.title = "Load Image"
    }

    private func setupLoadingView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.view.addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
        return view
    }

    private func setupIndicatorView() -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: .large)
        self.loadingView.addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        indicator.tintColor = .green
        return indicator
    }

    private func setupLinkContainer() -> UIView {
        let container = UIView()
        container.layer.cornerRadius = 30.0
        container.clipsToBounds = true
        self.view.addSubview(container)
        container.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(self.view.safeAreaLayoutGuide).inset(15.0)
        }
        container.backgroundColor = .orange
        return container
    }

    private func setuplinkTextField() -> UITextField {
        let textField = UITextField()
        textField.placeholder = "Paste your image link.."
        textField.textAlignment = .center
        self.linkLoadingContainer.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30.0)
            make.top.equalToSuperview().offset(10.0)
        }
        return textField
    }

    private func setupLinkButton() -> UIButton {
        let button = UIButton(type: .system)
        self.linkLoadingContainer.addSubview(button)
        button.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalTo(self.linkLoadingTextField.snp.bottom).offset(10.0)
        }
        button.setTitle("Load", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .green
        button.addTarget(self, action: #selector(handleLinkLoadButtonTap), for: .touchUpInside)
        return button
    }

    @objc private func handleLinkLoadButtonTap() {
        self.presenter.handleLoadButtonTap(with: self.linkLoadingTextField.text)
    }

    private func setupColletionView() -> UICollectionView {
        let collectionFlowLayout = UICollectionViewFlowLayout()
        collectionFlowLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionFlowLayout)

        collectionView.register(LoadImagesCell.self, forCellWithReuseIdentifier: "imagesCell")

        collectionView.delegate = self
        collectionView.dataSource = self

        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.linkLoadingContainer.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        collectionView.backgroundColor = .black
        return collectionView
    }
}

extension LoadImagesViewImpl: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.presenter.images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagesCell", for: indexPath) as! LoadImagesCell
        cell.image = self.presenter.images[indexPath.row]
        return cell
    }
}

extension LoadImagesViewImpl: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.presenter.handleCellTap(at: indexPath)
    }
}

extension LoadImagesViewImpl: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width / 3, height: self.view.frame.width / 3)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
}

extension LoadImagesViewImpl: LoadImagesView {
    func showLoadingView() {
        self.loadingView.isHidden = false
        self.loadingIndicator.startAnimating()
    }

    func hideLoadingView() {
        self.loadingView.isHidden = true
        self.loadingIndicator.stopAnimating()
    }

    func reloadData() {
        self.collectionView.reloadData()
    }
}
