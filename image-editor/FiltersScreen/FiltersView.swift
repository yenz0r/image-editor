//
//  FiltersView.swift
//  image-editor
//
//  Created by yenz0redd on 30.10.2019.
//  Copyright © 2019 yenz0redd. All rights reserved.
//

import UIKit

protocol FiltersView {
    func reloadData()
    func setupImage(_ image: UIImage?)
    func startAnimation()
    func stopAnimation()
}

class FiltersViewImpl: UIViewController {
    private var imageView: UIImageView!
    private var collectionView: UICollectionView!

    private let collectionViewHeight = 70.0

    var presenter: FiltersPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView = self.setupImageView()
        self.collectionView = self.setupCollectionView()
        self.configureNavBar()

        self.presenter.viewDidLoad()
    }

    private func setupImageView() -> UIImageView {
        let imageView = UIImageView()
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10.0)
            make.height.equalTo(imageView.snp.width)
        }
        return imageView
    }

    private func configureNavBar() {
        let barItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextButtonTapped))
        self.navigationItem.rightBarButtonItem = barItem
    }

    @objc private func nextButtonTapped() {
        self.presenter.handleNextButtonTap()
    }

    private func setupCollectionView() -> UICollectionView {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.register(FiltersCell.self, forCellWithReuseIdentifier: "filtersCell")
        collectionView.delegate = self
        collectionView.dataSource = self

        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(self.collectionViewHeight)
        }

        return collectionView
    }
}

extension FiltersViewImpl: FiltersView {
    func reloadData() {
        self.collectionView.reloadData()
    }

    func setupImage(_ image: UIImage?) {
        self.imageView.image = image
    }

    func startAnimation() {
        let alertController = UIAlertController(title: "Loading..", message: "Filter is in progress..", preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
    }

    func stopAnimation() {
        self.dismiss(animated: true, completion: nil)
    }

}

extension FiltersViewImpl: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.presenter.processedImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filtersCell", for: indexPath) as! FiltersCell
        cell.image =  self.presenter.processedImages[indexPath.row]
        return cell
    }
}

extension FiltersViewImpl: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.presenter.handleFilterChoose(at: indexPath)
    }
}

extension FiltersViewImpl: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionViewHeight, height: self.collectionViewHeight)
    }
}
